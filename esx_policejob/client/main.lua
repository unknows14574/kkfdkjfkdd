local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

function Ftext_esx_policejob(txt)
	return Config_esx_policejob.Txt[txt]
end

local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsFreezed       	        = false
local CopPed                    = 0
local shieldActive 				= false
local shieldEntity 				= nil
local hadPistolBouclier 		= false
local animDictBouclier 			= "combat@gestures@gang@pistol_1h@beckon"
local animName 					= "0"
local propBouclier 				= "prop_ballistic_shield"
local pistolBouclier 			= GetHashKey("WEAPON_PISTOL")

-- Gyrophare sur voiture civil
local netid 						= nil
local playerNetVehicle 				= nil
local playerVehicleClass 			= nil
local lightModel 					= 'hei_prop_wall_alarm_on'
local soundId 						= nil
local playerVehicle 				= nil
local currentSiren 					= 1
local sirensAreActive 				= false

zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

GUI.Time                        = 0

RegisterNetEvent('ESX:CloseAllMenu')
AddEventHandler('ESX:CloseAllMenu', function()
    ESX.UI.Menu.CloseAll()
end)

function police_OpenCloakroomMenu()

  local elements = {
    { label = Ftext_esx_policejob('citizen_wear'), value = 'garde_robe' }
  }

  table.insert(elements, {label = Ftext_esx_policejob('police_wear'), value = 'police_wear'})
  table.insert(elements, {label = "Tenue Intervention", value = 'give_tenu'})
  table.insert(elements, {label = "Tenue pilote Eagle", value = 'helico_wear'})
  table.insert(elements, {label = "Tenue pilote Mary", value = 'mary_wear'})
  table.insert(elements, {label = "Tenue K9 Unit", value = 'k9_wear'})
  table.insert(elements, {label = "Tenue HEAT", value = 'heat_wear'})
  table.insert(elements, {label = "Tenue SWAT", value = 'swat_wear'})
  table.insert(elements, {label = "Tenue Victor", value = 'victor_wear'})
  table.insert(elements, {label = "Tenue Cérémoniale", value = 'cere_wear'})
  
  
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = Ftext_esx_policejob('cloakroom'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)
      menu.close()
	  
		-- Garde robe
		if data.current.value == 'garde_robe' then

			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)

				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {label = dressing[i], value = i})
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'player_dressing',
					{
					  title    = 'Changer tenue',
					  align = 'right',
					  elements = elements,
					},
					function(data, menu)

					  TriggerEvent('skinchanger:getSkin', function(skin)

						ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)

							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							ESX.ShowNotification('Vous avez bien récupéré la tenue')
							HasLoadCloth = true

						end, data.current.value)

					  end)

					end,
					function(data, menu)
					  menu.close()
					  ESX.UI.Menu.CloseAll()
					end
				)

			end)

		end
	  
    if data.current.value == 'police_wear' then --police standard
      TriggerServerEvent("player:serviceOn", "police")
      if (PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.service == 1) then
        if (PlayerData.job.grade_name == "cadet") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                local clothesSkin = {
                  ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                  ['torso_1'] = 200,   ['torso_2'] = 1,
                  ['decals_1'] = 0,   ['decals_2'] = 0,
                  ['bproof_1'] = 13, ['bproof_2'] = 0,
                  ['arms'] = 20,
                  ['mask_1'] = -1, ['mask_2'] = 0,
                  ['pants_1'] = 126,   ['pants_2'] = 0,
                  ['shoes_1'] = 25,   ['shoes_2'] = 0,
                  ['helmet_1'] = 46,  ['helmet_2'] = 0,
                  ['chain_1'] = 13,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0, 
                  ['glasses_1'] = -1,  ['glasses_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
                local clothesSkin = {
                  ['tshirt_1'] = 27,  ['tshirt_2'] = 1,
                  ['torso_1'] = 202,   ['torso_2'] = 1,
                  ['decals_1'] = 0,   ['decals_2'] = 0,
                  ['bproof_1'] = 14, ['bproof_2'] = 0,
                  ['arms'] = 23,
                  ['mask_1'] = -1, ['mask_2'] = 0,
                  ['pants_1'] = 34,   ['pants_2'] = 0,
                  ['shoes_1'] = 25,   ['shoes_2'] = 0,
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = 8,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0,
                  ['glasses_1'] = -1,  ['glasses_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "recruit") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = 46,  ['helmet_2'] = 0,
                ['chain_1'] = 115,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
                local clothesSkin = {
                  ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                  ['torso_1'] = 202,   ['torso_2'] = 0,
                  ['decals_1'] = 0,   ['decals_2'] = 0,
                  ['bproof_1'] = 14, ['bproof_2'] = 0,
                  ['arms'] = 23,
                  ['mask_1'] = -1, ['mask_2'] = 0,
                  ['pants_1'] = 34,   ['pants_2'] = 0,
                  ['shoes_1'] = 25,   ['shoes_2'] = 0,
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = 8,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0,
                  ['glasses_1'] = -1,  ['glasses_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "officer") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                local clothesSkin = {
                  ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                  ['torso_1'] = 200,   ['torso_2'] = 0,
                  ['decals_1'] = 0,   ['decals_2'] = 0,
                  ['bproof_1'] = 13, ['bproof_2'] = 0,
                  ['arms'] = 20,
                  ['mask_1'] = -1, ['mask_2'] = 0,
                  ['pants_1'] = 35,   ['pants_2'] = 0,
                  ['shoes_1'] = 25,   ['shoes_2'] = 0,
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = 8,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0,
                  ['glasses_1'] = -1,  ['glasses_2'] = 0,
                  ['bags_1'] = 52, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "officer_2") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
            local clothesSkin = {
              ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
              ['torso_1'] = 327,   ['torso_2'] = 0,
              ['decals_1'] = 0,   ['decals_2'] = 0,
              ['bproof_1'] = 14, ['bproof_2'] = 0,
              ['arms'] = 23,
              ['mask_1'] = -1, ['mask_2'] = 0,
              ['pants_1'] = 34,   ['pants_2'] = 0,
              ['shoes_1'] = 25,   ['shoes_2'] = 0,
              ['helmet_1'] = -1,  ['helmet_2'] = 0,
              ['chain_1'] = 8,    ['chain_2'] = 0,
              ['ears_1'] = -1,     ['ears_2'] = 0,
              ['glasses_1'] = -1,  ['glasses_2'] = 0,
              ['bags_1'] = 52, ['bags_2'] = 0
            }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "officer_3") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 12,   ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52,     ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 11,   ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "sergeant") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 12,   ['decals_2'] = 2,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52,     ['bags_2'] = 1
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 11,   ['decals_2'] = 2,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 1
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "sergeant_2") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 12,   ['decals_2'] = 3,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52,     ['bags_2'] = 1
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 11,   ['decals_2'] = 3,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 1
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "lieutenant") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 45,   ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52,     ['bags_2'] = 2
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 52,   ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 2
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "lieutenant_2") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 45,   ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52,     ['bags_2'] = 2
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 52,   ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 2
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "capitaine_1") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 45,   ['decals_2'] = 1,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 3
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 52,   ['decals_2'] = 1,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 3
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "capitaine_2") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 45,   ['decals_2'] = 1,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 3
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 52,   ['decals_2'] = 1,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 3
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "coboss") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 45,   ['decals_2'] = 1,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 3
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 52,   ['decals_2'] = 1,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 3
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "boss") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 200,   ['torso_2'] = 0,
                ['decals_1'] = 45,   ['decals_2'] = 2,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 20,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 35,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 5
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 327,   ['torso_2'] = 0,
                ['decals_1'] = 52,   ['decals_2'] = 2,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 23,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 34,   ['pants_2'] = 0,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 5
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        end
        SetPedArmour(playerPed, 25)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end
  end
	  
	  if data.current.value == 'bullet_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['bproof_1'] = 0, ['bproof_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['bproof_1'] = 0, ['bproof_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end
            
        end)
 
        SetPedArmour(playerPed, 0)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
    end
    
    if data.current.value == 'give_tenu' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 49,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 16, ['bproof_2'] = 2,
            ['mask_1'] = 56,   ['mask_2'] = 1,
            ['arms'] = 17,
            ['pants_1'] = 31,   ['pants_2'] = 2,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 150,  ['helmet_2'] = 0,
            ['chain_1'] = 1,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = 82, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 9,  ['tshirt_2'] = 0,
            ['torso_1'] = 42,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 18, ['bproof_2'] = 1,
            ['mask_1'] = 56,   ['mask_2'] = 1,
            ['arms'] = 31,
            ['pants_1'] = 30,   ['pants_2'] = 2,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 74,  ['helmet_2'] = 0,
            ['chain_1'] = 17,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = 82, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 75)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'swat_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 49,   ['torso_2'] = 0,
            ['decals_1'] = 5,   ['decals_2'] = 0,
            ['bproof_1'] = 16, ['bproof_2'] = 1,
            ['mask_1'] = 52,   ['mask_2'] = 0,
            ['arms'] = 33,
            ['pants_1'] = 121,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 75,  ['helmet_2'] = 0,
            ['chain_1'] = 1,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = -1, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
            ['torso_1'] = 331,   ['torso_2'] = 0,
            ['decals_1'] = 5,   ['decals_2'] = 0,
            ['bproof_1'] = 18, ['bproof_2'] = 2,
            ['mask_1'] = 52,   ['mask_2'] = 1,
            ['arms'] = 18,
            ['pants_1'] = 127,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 74,  ['helmet_2'] = 0,
            ['chain_1'] = 17,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = -1, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 75)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'helico_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 336,   ['torso_2'] = 3,
            ['decals_1'] = 8,   ['decals_2'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 16,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 59,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 79,  ['helmet_2'] = 1,
            ['ears_1'] = 33,     ['ears_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0, 
            ['glasses_1'] = 5,  ['glasses_2'] = 3,
            ['chain_1'] = 0,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
            ['torso_1'] = 343,   ['torso_2'] = 0,
            ['decals_1'] = 7,   ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 18,
            ['mask_1'] = 121, ['mask_2'] = 0,
            ['pants_1'] = 136,   ['pants_2'] = 1,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['glasses_1'] = 11,  ['glasses_2'] = 3,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['chain_1'] = 17,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 25)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'mary_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 200,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 31,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 110,   ['pants_2'] = 0,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 16,  ['helmet_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = 5,  ['glasses_2'] = 3,
            ['bags_1'] = 52, ['bags_2'] = 0, 
            ['chain_1'] = 0,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
            ['torso_1'] = 202,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 23,
            ['pants_1'] = 79,   ['pants_2'] = 7,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 16,  ['helmet_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = 27,  ['glasses_2'] = 4,
            ['bags_1'] = 44, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 25)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'k9_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 93,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 12, ['bproof_2'] = 2,
            ['arms'] = 30,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 59,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 10,  ['helmet_2'] = 6,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
            ['torso_1'] = 84,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 11, ['bproof_2'] = 0,
            ['arms'] = 57,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 54,   ['pants_2'] = 1,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 10,  ['helmet_2'] = 2,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = 5,  ['glasses_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 50)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'heat_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 94,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 30,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 59,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
            
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
            ['torso_1'] = 85,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 57,
            ['mask_1'] = 121, ['mask_2'] = 0,
            ['pants_1'] = 61,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 44, ['bags_2'] = 0, 
            ['chain_1'] = 17,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 25)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'victor_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 93,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 171,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 15,   ['pants_2'] = 3,
            ['shoes_1'] = 2,   ['shoes_2'] = 0,
            ['helmet_1'] = 49,  ['helmet_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 44, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
            ['torso_1'] = 84,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 223,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 137,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = 38,  ['helmet_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 44, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)

      SetPedArmour(playerPed, 25)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'cere_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
            ['torso_1'] = 200,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['arms'] = 75,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 35,   ['pants_2'] = 0,
            ['shoes_1'] = 54,   ['shoes_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['chain_1'] = 8,     ['chain_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['helmet_1'] = 46,  ['helmet_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
            ['torso_1'] = 202,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['arms'] = 88,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 37,   ['pants_2'] = 0,
            ['shoes_1'] = 29,   ['shoes_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['chain_1'] = 0,     ['chain_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end   
      end)
    end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_policejob('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_policejob('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function police_OpenHeliMenu(station, partNum)
    local elements = {
	    {label = 'Maverick (pour interventions classiques)',  value = 'maverick2'},
	    {label = 'Polmav (lors d\'interventions dangeureuses)',  value = 'polmav'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'helicopter',
      {
        title    = "Garage d'hélicoptères",
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'maverick2' or data.current.value == 'polmav' then
          local helicopters = Config_esx_policejob.PoliceStations[station].Helicopters

          if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then
            ESX.Game.SpawnVehicle(data.current.value, {
              x = helicopters[partNum].SpawnPoint.x,
              y = helicopters[partNum].SpawnPoint.y,
              z = helicopters[partNum].SpawnPoint.z
            }, helicopters[partNum].Heading, function(vehicle)
              SetVehicleModKit(vehicle, 0)
              SetVehicleLivery(vehicle, 0)
            end)
            menu.close()
          end
        end
      end,
      function(data, menu)
        menu.close()

        CurrentAction     = 'menu_helicopter'
        CurrentActionMsg  = "Appuyez sur ~y~E~w~pour ouvrir le garage"
        CurrentActionData = {station = station}
      end
    )
end

function police_OpenArmoryMenu(station)

  if Config_esx_policejob.EnableArmoryManagement then

    local elements = {
	    {label = 'Prendre un bracelet électronique',  value = 'belectro'},
      {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
			{label = 'Ouvrir le stockage', value = 'get_stock'},
      {label = 'Déposer Argent (cash)',  value = 'put_money'},
	    {label = 'Déposer Argent (sale)',  value = 'put_blackmoney'}
    }

    if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'capitaine' or PlayerData.job2.grade_name == 'boss' or PlayerData.job2.grade_name == 'capitaine' then
      table.insert(elements, {label = 'Retirer Argent (cash)', value = 'get_money'})
      table.insert(elements, {label = 'Retirer Argent (sale)', value = 'get_blackmoney'})
      table.insert(elements, {label = 'Acheter des armes', value = 'buy_weapons'})
      table.insert(elements, {label = 'Ouvrir récéption achat d\'arme', value = 'get_weapon_buy'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = Ftext_esx_policejob('armory'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

		if data.current.value == 'belectro' then
      TriggerServerEvent('gps:itemadd', "braceletgps")
		end

		if data.current.value == 'put_money' then
				ESX.TriggerServerCallback('esx_police:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_snk',
						{
							title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
						}, function(data, menu)
		
							local amount = tonumber(data.value)
		
							if amount == nil then
								ESX.ShowNotification("Montant invalide")
							else
								menu.close()
								TriggerServerEvent('esx_police:putmoney', amount, 'police')
							end
		
						end, function(data, menu)
							menu.close()
						end)
					end)
		end
	  
		if data.current.value == 'get_money' then
				ESX.TriggerServerCallback('esx_police:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_snk',
					{
						title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_police:getmoney', amount, 'police')
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)

		end

		if data.current.value == 'put_blackmoney' then
				ESX.TriggerServerCallback('esx_police:CheckBlackMoney', function (_blackmoney)
					local blackmoney = _blackmoney

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_blackmoney_amount_mafia',
					{
						title = "[$" .. tonumber(blackmoney) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_police:putblackmoney', amount, blackmoney, 'police')
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)
		end
		if data.current.value == 'get_blackmoney' then
				ESX.TriggerServerCallback('esx_police:CheckBlackMoney', function (_blackmoney)
					local blackmoney = _blackmoney
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_blackmoney_amount_mafia',
					{
						title = "[$" .. tonumber(blackmoney) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_police:getblackmoney', amount, blackmoney, 'police')
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)
		end

    if data.current.value == 'buy_weapons' then
      ESX.TriggerServerCallback('esx_policejob:checkIfArmoryStorageOpenOneTime', function(oneTimeOpen)
        if (oneTimeOpen) then
          police_OpenBuyWeaponsMenu(station, "police")
        else
          TriggerEvent('Core:ShowNotification', "Vérifiez d'abord la récéption d'achat d'arme")
        end          
      end)
    end
    if data.current.value == 'get_weapon' then
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventoryName', 'society_police', 'big_fdo_weapons_storage')
      menu.close()
    end
    if data.current.value == 'get_weapon_buy' then
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventoryName', 'society_police', 'big_fdo_weapons_storage')
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventoryName', 'society_police_buy_inventory', 'big_fdo_weapon_buy_storage')
    end
    if data.current.value == 'get_stock' then
      TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_police')
      menu.close()
    end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = Ftext_esx_policejob('open_armory')
        CurrentActionData = {station = station}
      end
    )

  else

    local elements = {}

    for i=1, #Config_esx_policejob.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config_esx_policejob.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetItemLabel(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = Ftext_esx_policejob('armory'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = Ftext_esx_policejob('open_armory')
        CurrentActionData = {station = station}

      end
    )

  end

end

function fib_OpenArmoryMenu(station)
  if Config_esx_policejob.EnableArmoryManagement then

    local elements = {
      { label = Ftext_esx_policejob('citizen_wear'), value = 'garde_robe' },
	    {label = 'Prendre un bracelet électronique',  value = 'belectro'},
      {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
			{label = 'Ouvrir le stockage', value = 'get_stock'},
      {label = 'Déposer Argent (cash)',  value = 'put_money'},
	    {label = 'Déposer Argent (sale)',  value = 'put_blackmoney'}
    }

    if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'capitaine' or PlayerData.job2.grade_name == 'boss' or PlayerData.job2.grade_name == 'capitaine' then
	  table.insert(elements, {label = 'Retirer Argent (cash)', value = 'get_money'})
	  table.insert(elements, {label = 'Retirer Argent (sale)', value = 'get_blackmoney'})
    table.insert(elements, {label = 'Acheter des armes', value = 'buy_weapons'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = Ftext_esx_policejob('armory'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

    		-- Garde robe
		if data.current.value == 'garde_robe' then

			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)

				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {label = dressing[i], value = i})
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'player_dressing',
					{
					  title    = 'Changer tenue',
					  align = 'right',
					  elements = elements,
					},
					function(data, menu)

					  TriggerEvent('skinchanger:getSkin', function(skin)

						ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)

							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							ESX.ShowNotification('Vous avez bien récupéré la tenue')
							HasLoadCloth = true

						end, data.current.value)

					  end)

					end,
					function(data, menu)
					  menu.close()
					  ESX.UI.Menu.CloseAll()
					end
				)

			end)

    end
    
		if data.current.value == 'belectro' then
      TriggerServerEvent('gps:itemadd', "braceletgps")
		end

		if data.current.value == 'put_money' then
				ESX.TriggerServerCallback('esx_fib:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_snk',
						{
							title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
						}, function(data, menu)
		
							local amount = tonumber(data.value)
		
							if amount == nil then
								ESX.ShowNotification("Montant invalide")
							else
								menu.close()
								TriggerServerEvent('esx_police:putmoney', amount, 'fib')
							end
		
						end, function(data, menu)
							menu.close()
						end)
					end)
		end
	  
		if data.current.value == 'get_money' then
				ESX.TriggerServerCallback('esx_fib:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_snk',
					{
						title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_police:putmoney', amount, 'fib')
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)

		end

		if data.current.value == 'put_blackmoney' then
				ESX.TriggerServerCallback('esx_fib:CheckBlackMoney', function (_blackmoney)
					local blackmoney = _blackmoney

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_blackmoney_amount_mafia',
					{
						title = "[$" .. tonumber(blackmoney) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_police:putblackmoney', amount, blackmoney, 'fib')
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)
		end
		if data.current.value == 'get_blackmoney' then
				ESX.TriggerServerCallback('esx_fib:CheckBlackMoney', function (_blackmoney)
					local blackmoney = _blackmoney
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_blackmoney_amount_mafia',
					{
						title = "[$" .. tonumber(blackmoney) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_police:getblackmoney', amount, blackmoney, 'fib')
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)
		end
    
        if data.current.value == 'buy_weapons' then
          police_OpenBuyWeaponsMenu(station, "fib")
        end

        if data.current.value == 'get_weapon' then
          TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_fbi')
          menu.close()
        end

        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_fbi')
          menu.close()
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = Ftext_esx_policejob('open_armory')
        CurrentActionData = {station = station}
      end
    )

  else

    local elements = {}

    for i=1, #Config_esx_policejob.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config_esx_policejob.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetItemLabel(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = Ftext_esx_policejob('armory'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = Ftext_esx_policejob('open_armory')
        CurrentActionData = {station = station}

      end
    )

  end

end

function police_IsInVehicle()
	local ply = playerPed
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function police_OpenTestDrugDrunkMenu(player)

  if Config_esx_policejob.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local elements = {}

      if data.drunk ~= nil then
        table.insert(elements, {label = Ftext_esx_policejob('bac') .. ' ' .. data.drunk / 100 * 4 .. 'g/L de sang', value = nil})
      end

      if data.drug ~= nil then
        if data.drug > 0 then
          table.insert(elements, {label = Ftext_esx_policejob('duc') .. ' Positif', value = nil})
        else
          table.insert(elements, {label = Ftext_esx_policejob('duc') .. ' Négatif', value = nil})
        end
      else
        table.insert(elements, {label = Ftext_esx_policejob('duc') .. ' Négatif', value = nil})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'drunk_interaction',
        {
          title    = "Alcool/Drogue",
          align = 'right',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )
    end, GetPlayerServerId(player))
  end
end

function police_OpenSeeMyLicence()

	if Config_esx_policejob.EnableESXIdentity then
  
	  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData2', function(data)
  
		local elements = {}
  
		if data.licenses ~= nil then
  
		  table.insert(elements, {label = '--- Licenses ---', value = nil})
  
		  for i=1, #data.licenses, 1 do
			table.insert(elements, {label = data.licenses[i].label, value = nil})
		  end
		end
  
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'mylicence_interaction',
		  {
			title    = "Licences/Permis",
			align = 'right',
			elements = elements,
		  },
		  function(data, menu)
  
		  end,
		  function(data, menu)
			menu.close()
		  end
		)
	  end)
	end
end

RegisterNetEvent('esx_policejob:MyLicence')
AddEventHandler('esx_policejob:MyLicence', function()
	police_OpenSeeMyLicence()
end)

function OpenSeeLicenceMenu(player)

  if Config_esx_policejob.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local elements = {}

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'licence_interaction',
        {
          title    = "Licences/Permis",
          align = 'right',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )
    end, GetPlayerServerId(player))
  end
end

RegisterNetEvent('esx_policejob:SeeLicence')
AddEventHandler('esx_policejob:SeeLicence', function(player)
	ESX.UI.Menu.CloseAll()
	OpenSeeLicenceMenu(player)
end)


function police_OpenLicencesMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'licences_menu',
    {
      title    = "Licences/Permis",
      align = 'right',
      elements = {
        {label = "Donner licence PPA", value = 'license_ppa'},
        {label = "Voir les permis", value = 'license_see'},
        {label = 'Retirer licence d\'arme', value = 'license_weapon_remove'},
        {label = 'Retirer code', value = 'license_code_remove'},
        {label = 'Retirer permis moto', value = 'license_moto_remove'},
        {label = 'Retirer permis camion', value = 'license_camion_remove'},
        {label = 'Retirer permis voiture', value = 'license_voiture_remove'},
        {label = 'Retirer permis chasse', value = 'license_chasse_remove'},
        {label = 'Retirer permis peche', value = 'license_peche_remove'},
        {label = 'Restituer code', value = 'license_code_add'},
        {label = 'Restituer permis moto', value = 'license_moto_add'},
        {label = 'Restituer permis camion', value = 'license_camion_add'},
        {label = 'Restituer permis voiture', value = 'license_voiture_add'},
        {label = 'Restituer permis chasse', value = 'license_chasse_add'},
        {label = 'Restituer permis peche', value = 'license_peche_add'},
        {label = 'Retirer visite médicale', value = 'vmedic_remove'},
        {label = 'Retirer certificat médicale', value = 'cmedic_remove'}
      },
    },
    function(data, menu)

      local player, distance = ESX.Game.GetClosestPlayer()

      if distance ~= -1 and distance <= 3.0 then
        if data.current.value == 'license_ppa' then
          TriggerServerEvent('esx_policejob:giveLicense', GetPlayerServerId(player), 'ppa', "permis port d'arme")
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a donné `PERMIS DE PORT D'ARMES` à **"..GetPlayerName(player).."**", "Green")
        end
	  
        if data.current.value == 'license_see' then
          OpenSeeLicenceMenu(player)
        end

        if data.current.value == 'vmedic_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'vmedic')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `VISITE MEDICAL` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'cmedic_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'cmedic')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `CERTIFICAT MEDICAL` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_weapon_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'ppa')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `PERMIS DE PORT D'ARMES` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_code_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'dmv')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `CODE DE LA ROUTE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_moto_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'drive_bike')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `PERMIS MOTO` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_camion_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'drive_truck')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `PERMIS CAMION` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_voiture_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'drive')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `PERMIS VOITURE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_chasse_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'chasse')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `PERMIS CHASSE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_peche_remove' then
          TriggerServerEvent('esx_policejob:deletelicense', GetPlayerServerId(player), 'peche')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a retiré `PERMIS PECHE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_code_add' then
          TriggerServerEvent('esx_policejob:addlicense', GetPlayerServerId(player), 'dmv')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a restitué `CODE DE LA ROUTE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_moto_add' then
          TriggerServerEvent('esx_policejob:addlicense', GetPlayerServerId(player), 'drive_bike')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a restitué `PERMIS MOTO` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_camion_add' then
          TriggerServerEvent('esx_policejob:addlicense', GetPlayerServerId(player), 'drive_truck')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a restitué `PERMIS CAMION` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_voiture_add' then
          TriggerServerEvent('esx_policejob:addlicense', GetPlayerServerId(player), 'drive')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a restitué `PERMIS VOITURE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_chasse_add' then
          TriggerServerEvent('esx_policejob:addlicense', GetPlayerServerId(player), 'chasse')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a restitué `PERMIS CHASSE` à **"..GetPlayerName(player).."**", "Red")
        end

        if data.current.value == 'license_peche_add' then
          TriggerServerEvent('esx_policejob:addlicense', GetPlayerServerId(player), 'peche')
          TriggerServerEvent('CoreLog:SendDiscordLog', "POLICE - Papiers", "**" .. GetPlayerName(PlayerId()) .. "** a restitué `PERMIS PECHE` à **"..GetPlayerName(player).."**", "Red")
        end

      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

RegisterNetEvent('esx_policejob:licencechecker')
AddEventHandler('esx_policejob:licencechecker', function(player)
	ESX.UI.Menu.CloseAll()
	police_OpenLicencesMenu(player)
end)

function police_EnableShield()
  shieldActive = true
  local ped = playerPed
  local pedPos = GetEntityCoords(ped, false)
  
  RequestAnimDict(animDictBouclier)
  while not HasAnimDictLoaded(animDictBouclier) do
      Citizen.Wait(100)
  end

  TaskPlayAnim(ped, animDictBouclier, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

  RequestModel(GetHashKey(propBouclier))
  while not HasModelLoaded(GetHashKey(propBouclier)) do
      Citizen.Wait(100)
  end

  local shield = CreateObject(GetHashKey(propBouclier), pedPos.x, pedPos.y, pedPos.z, 1, 1, 1)
  shieldEntity = shield
  AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
  SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))

  if HasPedGotWeapon(ped, pistolBouclier, 0) or GetSelectedPedWeapon(ped) == pistolBouclier then
      SetCurrentPedWeapon(ped, pistolBouclier, 1)
      hadPistolBouclier = true
  else
      GiveWeaponToPed(ped, pistolBouclier, 300, 0, 1)
      SetCurrentPedWeapon(ped, pistolBouclier, 1)
      hadPistolBouclier = false
  end
  SetEnableHandcuffs(ped, true)
end

function police_DisableShield()
  local ped = playerPed
  DeleteEntity(shieldEntity)
  ClearPedTasksImmediately(ped)
  SetWeaponAnimationOverride(ped, GetHashKey("Default"))

  if not hadPistolBouclier then
      RemoveWeaponFromPed(ped, pistolBouclier)
  end
  SetEnableHandcuffs(ped, false)
  hadPistolBouclier = false
  shieldActive = false
end

function police_OpenAccessoiresMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Accessoires_menu',
    {
      title    = "Accessoires",
      align = 'right',
      elements = {
    {label = "Mettre gilet pare-balles léger", value = 'gilet1_put'},
    {label = "Mettre gilet pare-balles léger SWAT", value = 'giletl2_put'},
    {label = "Mettre gilet pare-balles normal", value = 'gilet2_put'},
    {label = "Mettre gilet pare-balles négociateur", value = 'gilet3_put'},
    {label = "Mettre gilet pare-balles lourd", value = 'gilet4_put'},
    {label = "Mettre l'imperméable", value = 'veste_put'},
    {label = 'Prendre Bouclier', value = 'bouclier_give'},
		{label = "Mettre Oreillette", value = 'Oreillette_put'},
    {label = "Mettre Bonnet", value = 'Bonnet_put'},
    {label = "Mettre Gants", value = 'gants_put'},
    {label = 'Mettre Masque', value = 'Masque_put'},
		{label = "Mettre Casquette", value = 'Casquette_put'},
		{label = "Mettre Casque #1", value = 'Casque_put'},
		{label = "Mettre Casque #2", value = 'Casque2_put'},
    {label = "Mettre Chapeau cérémonial", value = 'Casque4_put'},
    {label = 'Retirer le gilet pare-balle', value = 'gilet_remove'},
    {label = "Retirer Bonnet, Casque, Casquette", value = 'Casque_remove'},
    {label = "Retirer gants", value = 'gants_remove'},
    {label = 'Retirer Masque, Oreillette', value = 'Masque_remove'},
    {label = "Retirer l'imperméable", value = 'veste_remove'},
    {label = 'Poser Bouclier', value = 'bouclier_remove'}

      },
    },
    function(data, menu)

  if data.current.value == 'bouclier_give' then
    police_EnableShield()
  end

  if data.current.value == 'bouclier_remove' then
    police_DisableShield()
  end

	if data.current.value == 'gilet1_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 18, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 22, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Usage Gilet", "**`" .. GetPlayerName(PlayerId()) .. "`** a mis un gilet pare-balles léger", "Purple")
    SetPedArmour(playerPed, 35)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end


  if data.current.value == 'giletl2_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 18, ['bproof_2'] = 8
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 22, ['bproof_2'] = 6
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Usage Gilet", "**`" .. GetPlayerName(PlayerId()) .. "`** a mis un gilet pare-balles léger SWAT", "Purple")
    SetPedArmour(playerPed, 50)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end
	

	if data.current.value == 'gilet2_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 12, ['bproof_2'] = 3
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 11, ['bproof_2'] = 3
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Usage Gilet", "**`" .. GetPlayerName(PlayerId()) .. "`** a mis un gilet pare-balles normal", "Purple")
    SetPedArmour(playerPed, 50)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end


  if data.current.value == 'gilet3_put' then
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then

        local clothesSkin = {
          ['bproof_1'] = 18, ['bproof_2'] = 9
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else

        local clothesSkin = {
          ['bproof_1'] = 22, ['bproof_2'] = 5
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      end	
    end)
    TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Usage Gilet", "**`" .. GetPlayerName(PlayerId()) .. "`** a mis un gilet pare-balles négociateur", "Purple")
    SetPedArmour(playerPed, 50)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end


  if data.current.value == 'gilet4_put' then
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then

        local clothesSkin = {
          ['bproof_1'] = 16, ['bproof_2'] = 2
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else

        local clothesSkin = {
          ['bproof_1'] = 18, ['bproof_2'] = 1
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      end	
    end)
    TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Usage Gilet", "**`" .. GetPlayerName(PlayerId()) .. "`** a mis un gilet pare-balles lourd", "Purple")
    SetPedArmour(playerPed, 150)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end

  if data.current.value == 'veste_put' then
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then

        local clothesSkin = {
          ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
          ['torso_1'] = 217,   ['torso_2'] = 8,
          ['decals_1'] = -1,   ['decals_2'] = 0,
          ['arms'] = 44,
          ['bproof_1'] = 0, ['bproof_2'] = 0,
          ['bags_1'] = 0, ['bags_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else

        local clothesSkin = {
          ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
          ['torso_1'] = 190,   ['torso_2'] = 6,
          ['decals_1'] = -1,   ['decals_2'] = 0,
          ['arms'] = 53,
          ['bproof_1'] = 0, ['bproof_2'] = 0,
          ['bags_1'] = 0, ['bags_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      end	
    end)
  end

  if data.current.value == 'veste_remove' then
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then

        local clothesSkin = {
          ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
          ['torso_1'] = 190,   ['torso_2'] = 0,
          ['arms'] = 0,
          ['bproof_1'] = 13, ['bproof_2'] = 0,
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else

        local clothesSkin = {
          ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
          ['torso_1'] = 192,   ['torso_2'] = 0,
          ['arms'] =14,
          ['bproof_1'] = 14, ['bproof_2'] = 0,
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      end	
    end)
  end

	if data.current.value == 'gilet_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 13, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 14, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end

	if data.current.value == 'Oreillette_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = 121, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['mask_1'] = 121, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	
	if data.current.value == 'Bonnet_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 5, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 5, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end
  
  if data.current.value == 'gants_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['arms'] = 38
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['arms'] = 36
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end
  
  if data.current.value == 'gants_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['arms'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['arms'] = 14
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	
	if data.current.value == 'Casque_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 125, ['helmet_2'] = 18
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 124, ['helmet_2'] = 18
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	if data.current.value == 'Casque_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = -1, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = -1, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	  
	if data.current.value == 'Casque2_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 16, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 16, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
  
	if data.current.value == 'Casque4_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 46,  ['helmet_2'] = 0,
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 1, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	
	if data.current.value == 'Casquette_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 10, ['helmet_2'] = 6
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 10, ['helmet_2'] = 2
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	  
	if data.current.value == 'Masque_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = 56, ['mask_2'] = 1
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['mask_1'] = 56, ['mask_2'] = 1
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
    end
	if data.current.value == 'Masque_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = -1, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['mask_1'] = -1, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
    end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function onscreenKeyboard()
	local _return = nil

	DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP8", "", "", "", "", "", 99)
	while true do
		DisableAllControlActions(0)
		HideHudAndRadarThisFrame()
		Citizen.Wait(0)

		if UpdateOnscreenKeyboard() == 1 then
			_return = GetOnscreenKeyboardResult()
			break
		elseif UpdateOnscreenKeyboard() == 2 or UpdateOnscreenKeyboard() == 3 then
			break
		end
	end

	return _return
end

local localication = nil 
function DeleteBlip()
    RemoveBlip(localisation)
end

function police_OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()
  
  local elements1 = {}
  
  if (police_IsInVehicle()) then 
    local vehicle = GetVehiclePedIsIn( playerPed, false )
      table.insert(elements1, {label = 'Radar Véhicule', value = 'vehicle_radar'} )
    --end
  end
  
  table.insert(elements1, {label = "[Debug] Supprimes les blips", value = 'debugblip'} )
  table.insert(elements1, {label = "Accessoires", value = 'accessoires'} )
  table.insert(elements1, {label = "Mettre en prison", value = 'jail_menu'} )
  table.insert(elements1, {label = Ftext_esx_policejob('citizen_interaction'), value = 'citizen_interaction'} )
  table.insert(elements1, {label = Ftext_esx_policejob('vehicle_interaction'), value = 'vehicle_interaction'} )
  table.insert(elements1, {label = Ftext_esx_policejob('object_spawner'),      value = 'object_spawner'} )
  table.insert(elements1, {label = "Retirer objets",      value = 'object_remove'} )
  table.insert(elements1, {label = "Unité Canine",      value = 'k9_unit'} )
  table.insert(elements1, {label = "Poser/Récupérer votre radar",      value = 'radar'} )
  table.insert(elements1, {label = "Centrale des bracelets electroniques",      value = 'centralebracelets'} )
  if (PlayerData.job.grade_name == 'boss' or PlayerData.job2.grade_name == 'boss') or (PlayerData.job.grade_name == 'coboss' or PlayerData.job2.grade_name == 'coboss') or (PlayerData.job.grade_name == 'capitaine_2' or PlayerData.job2.grade_name == 'capitaine_2') or (PlayerData.job.grade_name == 'capitaine_1' or PlayerData.job2.grade_name == 'capitaine_1') then
    table.insert(elements1, {label = "Attribuer un matricule",      value = 'attrimatri'} )
  end


  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'police_actions',
    {
      title    = 'Police',
      align = 'right',
	  elements = elements1
    },
    function(data, menu)
  
    if data.current.value == 'debugblip' then
      DeleteBlip()
    end
	
    if data.current.value == 'radar' then
      POLICE_radar()
    end

    if data.current.value == 'centralebracelets' then
      menu.close()
      TriggerEvent('Nebula_jobs:openBraceletsMenu')
    end

    if data.current.value == 'attrimatri' then
      local player, distance = ESX.Game.GetClosestPlayer()
      if player ~= -1 and distance <= 3.0 then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'attrimatri',
        {title = "Attribuer un matricule"}, 	
          function(data3, menu3)
            local matricule = tostring(data3.value)
            if matricule == nil then
              TriggerEvent('Core:ShowNotification', "Merci de mettre un matricule.")
            else
              menu3.close()
              TriggerEvent('Core:ShowNotification', "Vous avez attribuer le matricule ~y~"..matricule.."~w~.")
              TriggerServerEvent('esx_policejob:AttributeMatricule', GetPlayerServerId(player), matricule)
            end
          end, function(data3, menu3)
          menu3.close()
        end)
      else
        TriggerEvent('Core:ShowNotification', "Aucun joueur en face de vous.")
      end
    end
	
    if data.current.value == 'accessoires' then
      police_OpenAccessoiresMenu()
    end
  
    if data.current.value == 'jail_menu' then
      local pedCoords = coords
      local JailLoc = zones[GetNameOfZone(pedCoords.x, pedCoords.y, pedCoords.z)]
      
      if JailLoc == "Bolingbroke Penitentiary" then
        TriggerEvent("esx-qalle-jail:openJailMenu")
      else
        TriggerEvent('Core:ShowAdvancedNotification', "~b~Bolingbroke Penitentiary", "~y~Notification", "Tu n\'es pas à la prison.", 'CHAR_LESTER', 1, false, false, 140)
      end
    end

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = Ftext_esx_policejob('citizen_interaction'),
            align = 'right',
            elements = {
              {label = 'Licences/Permis',            value = 'license_check'},
              {label = 'Alcool/Drogues',            value = 'drunk_check'},
              {label = Ftext_esx_policejob('search'),        value = 'body_search'},
              {label = Ftext_esx_policejob('handcuff'),    value = 'handcuff'},
              {label = Ftext_esx_policejob('drag'),      value = 'drag'},
              {label = 'Poser un bracelet au suspect',            value = 'braceletgpspose'},
              {label = 'Retirer le bracelet au suspect',            value = 'braceletgpsremove'},
              {label = Ftext_esx_policejob('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = Ftext_esx_policejob('out_the_vehicle'), value = 'out_the_vehicle'},
              {label = Ftext_esx_policejob('fine'),            value = 'fine'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

			        if data2.current.value == 'freeze' then
                isFreezed = not isFreezed
                if isFreezed then
                  FreezeEntityPosition(GetPlayerServerId(player), true)
                else
                  FreezeEntityPosition(GetPlayerServerId(player), false)
                end
              end
			
              if data2.current.value == 'license_check' then
                police_OpenLicencesMenu(player)
              end

              if data2.current.value == 'braceletgpspose' then
                TriggerServerEvent('esx_policejob:giveBraceletGps', GetPlayerServerId(player))
              end

              if data2.current.value == 'braceletgpsremove' then
                TriggerServerEvent('esx_policejob:removeBraceletGps', GetPlayerServerId(player))
              end

              if data2.current.value == 'drunk_check' then
                police_OpenTestDrugDrunkMenu(player)
              end

              if data2.current.value == 'identity_card' then
                police_OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                TriggerServerEvent('core_inventory:custom:searchPlayer', GetPlayerServerId(player))
                -- TriggerServerEvent('core_inventory:server:openInventory', GetPlayerServerId(player), 'otherplayer')
                TriggerServerEvent('esx_policejob:fouiller', GetPlayerServerId(player))
              end

              if data2.current.value == 'handcuff' then
                RequestAnimDict('mp_arresting')

                while not HasAnimDictLoaded('mp_arresting') do
                  Wait(100)
                end
                TaskGoToEntity(playerPed, GetPlayerPed(player), 2000, 20, 100, 0, 0)
                TaskLookAtEntity(playerPed, GetPlayerPed(player), 2000, 2048, 3)
                Citizen.Wait(500)
                TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player), GetEntityHeading(playerPed))
                Citizen.Wait(50)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, "handcuff", 0.1)
                TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8, 2000, 49, 0, 0, 0, 0)
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                police_OpenFineMenu(player)
              end           
            else
              ESX.ShowNotification(Ftext_esx_policejob('no_players_nearby'))
            end
          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end
	  
	  if data.current.value == 'vehicle_radar' then
		  TriggerEvent('esx_vehradar:On')
	  end

      if data.current.value == 'vehicle_interaction' then
	  
        local interactionMenu 	= {
          {label = "Plaque du véhicule", value = 'vehicle_infos1'},
          {label = "Vérifier le véhicule le plus proche", value = 'vehicle_infos'},
          {label = "Mettre le véhicule en fourrière", value = 'del_vehicle'}
        }
        if GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) < 7 then
          table.insert(interactionMenu, {label = "Mettre/Enlever gyrophare", value = 'vehicle_gyro'})
        end
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'vehicle_interaction',
            {
              title    = Ftext_esx_sheriff('vehicle_interaction'),
              align = 'right',
              elements = interactionMenu,
            },
            function(data2, menu2)  
              local vehicle 	= GetClosestVehicle(GetEntityCoords(PlayerPedId()),  3.0,  0,  71)
  
              if data2.current.value == 'vehicle_infos1' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vehinfo1',
                {title = "Plaque du véhicule"}, 	
                  function(data3, menu3)
                    local plate = data3.value
                    if plate == nil then
                      TriggerEvent('Core:ShowNotification', "Merci de mettre une plaque.")
                    else
                      menu3.close()
                      TriggerServerEvent('esx_policejob:GetPlate', plate)
                    end
                  end, function(data3, menu3)
                  menu3.close()
                end)
              end
  
              if data2.current.value == 'vehicle_infos' then
                local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                  if DoesEntityExist(vehicle) then
                    police_OpenVehicleInfosMenu(vehicleData)
                  else
                    TriggerEvent('Core:ShowNotification', 'Aucun véhicule a proximité.')
                  end
              end
        
              if data2.current.value == 'vehicle_gyro' then
                TriggerEvent('copsrp_gyrophare:toggleBeacon')
                ESX.UI.Menu.CloseAll()
              end

              if data2.current.value == 'del_vehicle' then       
                local ped = playerPed
                if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        
                  if ( IsPedSittingInAnyVehicle( ped ) ) then
                    local vehicle = GetVehiclePedIsIn( ped, false )
        
                    if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then
                      ESX.ShowNotification(Ftext_esx_policejob('vehicle_impounded'))
                      -- TriggerEvent('harybo_permanent:forgetveh', vehicle)
                      SetEntityAsMissionEntity( vehicle, true, true )
                      NetworkRequestControlOfEntity(vehicle)
                      local timeout = 2000
                      while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do 
                        Wait(100) 
                        timeout = timeout - 100
                      end
                      local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) 
                      deleteCar( vehicle )
                      TriggerEvent('Core:ShowNotification', "Le véhicule ~b~"..plate.."~w~ a été mis en fourrière")
                      TriggerServerEvent('Core:SetVehicleFourriere', plate)
                    else
                      ESX.ShowNotification(Ftext_esx_policejob('must_seat_driver'))
                    end
                  else
                    local playerPos =  GetEntityCoords(ped)
                    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, 3.0, 0.0 )
                    local vehicle = police_GetVehicleInDirection( playerPos, inFrontOfPlayer )
                        
                    if ( DoesEntityExist( vehicle ) ) then
                      ESX.ShowNotification(Ftext_esx_policejob('vehicle_impounded'))
                      SetEntityAsMissionEntity( vehicle, true, true )
                      NetworkRequestControlOfEntity(vehicle)
                      local timeout = 2000
                      while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do 
                        Wait(100) 
                        timeout = timeout - 100
                      end
                      local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                      deleteCar( vehicle )
                      TriggerServerEvent('Core:SetVehicleFourriere', plate)
                      TriggerEvent('Core:ShowNotification', "Le véhicule ~b~"..plate.."~w~ a été mis en fourrière")
                    else
                      ESX.ShowNotification(Ftext_esx_policejob('must_near'))
                    end
                  end
                end
              end
            end,
            function(data2, menu2)
              menu2.close()
            end
          )
        end
	  
	  if data.current.value == 'object_remove' then
	  
		  local trackedEntities = {
        'prop_roadcone02a',
        'prop_barrier_work06a',
        'p_ld_stinger_s',
        'prop_boxpile_07d',
        'hei_prop_cash_crate_half_full'
		  }

		  
		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do

		  local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  1.0,  GetHashKey(trackedEntities[i]), false, false, false)

		  if DoesEntityExist(object) then

			DeleteObject(object)

		  end

		end
	  
	  end

    if data.current.value == 'k9_unit' then
      TriggerEvent('esx_policedog:openMenu')
    end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = Ftext_esx_policejob('traffic_interaction'),
            align = 'right',
            elements = {
              {label = Ftext_esx_policejob('cone'),     value = 'prop_roadcone02a'},
              {label = Ftext_esx_policejob('barrier'), value = 'prop_barrier_work06a'},
              {label = "Barrière renforcée", value = 'prop_barrier_work06a2'},
              {label = Ftext_esx_policejob('spikestrips'),    value = 'p_ld_stinger_s'},
              {label = Ftext_esx_policejob('box'),   value = 'prop_boxpile_07d'},
              --{label = Ftext_esx_policejob('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)
            local model     = data2.current.value

            if model == "prop_barrier_work06a2" then
              model = "prop_barrier_work06a"
            end
            
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
              if data2.current.value == "prop_barrier_work06a2" then
                FreezeEntityPosition(obj, true)
              end
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function fib_OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()
  
  local elements1 = {}
  
  table.insert(elements1, {label = "Accessoires", value = 'accessoires'} )
  table.insert(elements1, {label = "Mettre en prison", value = 'jail_menu'} )
  table.insert(elements1, {label = Ftext_esx_policejob('citizen_interaction'), value = 'citizen_interaction'} )
  table.insert(elements1, {label = Ftext_esx_policejob('vehicle_interaction'), value = 'vehicle_interaction'} )
  table.insert(elements1, {label = Ftext_esx_policejob('object_spawner'),      value = 'object_spawner'} )
  table.insert(elements1, {label = "Retirer objets",      value = 'object_remove'} )

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'police_actions',
    {
      title    = 'Police',
      align = 'right',
	  elements = elements1
    },
    function(data, menu)
	
	if data.current.value == 'accessoires' then
		police_OpenAccessoiresMenu()
  end
  
  if data.current.value == 'jail_menu' then
    local pedCoords = coords
    local JailLoc = zones[GetNameOfZone(pedCoords.x, pedCoords.y, pedCoords.z)]
    
    if JailLoc == "Bolingbroke Penitentiary" then
      TriggerEvent("esx-qalle-jail:openJailMenu")
    else
      TriggerEvent('Core:ShowAdvancedNotification', "~b~Bolingbroke Penitentiary", "~y~Notification", "Tu n\'es pas à la prison.", 'CHAR_LESTER', 1, false, false, 140)
    end
  end

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = Ftext_esx_policejob('citizen_interaction'),
            align = 'right',
            elements = {
              {label = 'Licences/Permis',            value = 'license_check'},
              {label = 'Alcool/Drogues',            value = 'drunk_check'},
              {label = Ftext_esx_policejob('search'),        value = 'body_search'},
              {label = Ftext_esx_policejob('handcuff'),    value = 'handcuff'},
			  {label = "Freeze troller",    value = 'freeze'},
              {label = Ftext_esx_policejob('drag'),      value = 'drag'},
              {label = Ftext_esx_policejob('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = Ftext_esx_policejob('out_the_vehicle'), value = 'out_the_vehicle'},
              {label = Ftext_esx_policejob('fine'),            value = 'fine'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

			  if data2.current.value == 'freeze' then
				isFreezed = not isFreezed
				if isFreezed then
					FreezeEntityPosition(GetPlayerServerId(player), true)
				else
					FreezeEntityPosition(GetPlayerServerId(player), false)
				end
              end
			
              if data2.current.value == 'license_check' then
                police_OpenLicencesMenu(player)
              end
              if data2.current.value == 'drunk_check' then
                police_OpenTestDrugDrunkMenu(player)
              end

              if data2.current.value == 'identity_card' then
                police_OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                TriggerServerEvent('core_inventory:custom:searchPlayer', GetPlayerServerId(player))
                -- TriggerServerEvent('core_inventory:server:openInventory', GetPlayerServerId(player), 'otherplayer')
						    TriggerServerEvent('esx_policejob:fouiller', GetPlayerServerId(player))
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                police_OpenFineMenu(player)
              end

            else
              ESX.ShowNotification(Ftext_esx_policejob('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then
	  
		local interactionMenu 	= {
			{label = "Plaque du véhicule", value = 'vehicle_infos1'},
			{label = "Numéro de serie", value = 'vehicle_infos'}
		}
		
		if GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) < 7 then
			table.insert(interactionMenu, {label = "Mettre/Enlever gyrophare", value = 'vehicle_gyro'})
		end

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    	= Ftext_esx_policejob('vehicle_interaction'),
            align 		= 'right',
            elements 	= interactionMenu,
          },
          function(data2, menu2)
			
			local vehicle 	= GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

			if data2.current.value == 'impound' then
				ESX.Game.DeleteVehicle(vehicle) 
				ESX.ShowNotification("Mise en fourière")
			end

			if data2.current.value == 'vehicle_infos1' then
				--local plate = onscreenKeyboard()
				--TriggerServerEvent('esx_policejob:GetPlate', plate)
				
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vehinfo',
				{title = "Plaque du véhicule"}, 	
					function(data3, menu3)
					local plate = data3.value
					if plate == nil then
						ESX.ShowNotification("Merci de mettre une plaque")
					else
						menu3.close()
						TriggerServerEvent('esx_policejob:GetPlate', plate)
					end
					end, function(data3, menu3)
					menu3.close()
				end)
				
				
            end
			
            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

			  if data2.current.value == 'vehicle_infos' then
                police_OpenVehicleInfosMenu(vehicleData)
              end
			  
              if data2.current.value == 'hijack_vehicle' then

                
                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', Ftext_esx_policejob('vehicleFtext_esx_policejobnlocked'))
					  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)

                    end)

                  end

                end

              end

            elseif not police_IsInVehicle() then
              ESX.ShowNotification(Ftext_esx_policejob('no_vehicles_nearby'))
            end
			
			if data2.current.value == 'vehicle_gyro' then
				TriggerEvent('copsrp_gyrophare:toggleBeacon')
				ESX.UI.Menu.CloseAll()
			end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end
	  
	  if data.current.value == 'object_remove' then
	  
		  local trackedEntities = {
			'prop_roadcone02a',
			'prop_barrier_work06a',
			'p_ld_stinger_s',
			'prop_boxpile_07d',
			'hei_prop_cash_crate_half_full'
		  }

		  
		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do

		  local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  1.0,  GetHashKey(trackedEntities[i]), false, false, false)

		  if DoesEntityExist(object) then

			DeleteObject(object)

		  end

		end
	  
	  end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = Ftext_esx_policejob('traffic_interaction'),
            align = 'right',
            elements = {
              {label = Ftext_esx_policejob('cone'),     value = 'prop_roadcone02a'},
              {label = Ftext_esx_policejob('barrier'), value = 'prop_barrier_work06a'},
              {label = Ftext_esx_policejob('spikestrips'),    value = 'p_ld_stinger_s'},
              {label = Ftext_esx_policejob('box'),   value = 'prop_boxpile_07d'},
              --{label = Ftext_esx_policejob('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function police_OpenIdentityCardMenu(player)

  if Config_esx_policejob.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local elements = {
      }

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = Ftext_esx_policejob('citizen_interaction'),
          align = 'right',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = Ftext_esx_policejob('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = Ftext_esx_policejob('bac') .. data.drunk / 100 * 4 .. 'g/L de sang', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = Ftext_esx_policejob('citizen_interaction'),
          align = 'right',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function police_OpenAdminFouille(id)

  ESX.ShowNotification(id)

  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

    local elements = {}

	table.insert(elements, {label = '<span style="color:green;">Cash: $' .. data.money, value = nil})
	
	--table.insert(elements, {label = '<span style="color:green;">Bank: $' .. data.bank, value = nil})
	
    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end
	
	table.insert(elements, {label = '<span style="color:red;">Argent Sale: $' .. blackMoney, value = nil})

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = Ftext_esx_policejob('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = Ftext_esx_policejob('search'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(-1))

end

function police_police_OpenBodySearchMenu2(player)

  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

    local elements = {}

	table.insert(elements, {label = '<span style="color:green;">Argent: $' .. data.money, value = nil})
	
    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end
	
	table.insert(elements, {label = '<span style="color:red;">Argent Sale: $' .. blackMoney, value = nil})

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = Ftext_esx_policejob('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = Ftext_esx_policejob('search'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end


function police_OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

    local elements = {}

    table.insert(elements, 
    {
      label = '<span style="color:white;">Argent: $' .. data.money, 
      value = nil,
      itemType = 'item_amount_choose_money',
      amount = data.money
    })
    
    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = Ftext_esx_policejob('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = Ftext_esx_policejob('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = Ftext_esx_policejob('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = Ftext_esx_policejob('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = Ftext_esx_policejob('search'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          police_OpenBodySearchMenu(player)

        elseif data.current.value == nil and itemType == 'item_amount_choose_money' then

          ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choix_montant',
          {
            title = "[" .. tonumber(amount) .. "$] d'argent sur la personne"
          }, function(data2, menu2)

            local amountSelect = tonumber(data2.value)

            if amountSelect == nil or amountSelect > amount then
              ESX.ShowNotification("Montant invalide")
            else
              TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amountSelect)

              police_OpenBodySearchMenu(player)              
            end

            end, function(data2, menu2)
              menu2.close()
            end)

          end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function police_OpenBillMenu()

	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}
  
    ESX.TriggerServerCallback('esx_policejob:GetBilling', function(bill)
      for _,v in pairs(bill) do
        if v.lastname and v.firstname then
          local pol = '<span style="color:green;">[' .. v.id .. '] <span style="color:white;">' .. v.lastname .. " " .. v.firstname .. ' [<span style="color:yellow;">' .. v.amount .. ' $]' 
          table.insert(elements, {label = pol, value = v})
        else
          local pol = '<span style="color:green;">[' .. v.id .. '] [<span style="color:white;">' .. v.identifier .. '<span style="color:green;">]' .. ' [<span style="color:yellow;">' .. v.amount .. ' $]' 
          table.insert(elements, {label = pol, value = v})
        end
      end
  
		  ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'billZ',
		  {
			  title    = 'Factures impayées',
			  align = 'right',
			  elements = elements,
		  },
	  function(data, menu)
  
		local elements2 = {
			{label = 'Oui', value = 'yes'},
		  {label = 'Non', value = 'no'}
		  }
  
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billZZ', {
			title    = "Voulez vous faire sauter cette amende de $" .. data.current.value.amount .. "?",
			align    = 'center',
			elements = elements2,
  
		  }, 
		  function(data2, menu2)
  
			if data2.current.value == 'yes' then
        ESX.UI.Menu.CloseAll()
        if PlayerData.job.grade >= 9 then
          if data.current.value.society == "society_police" then
            TriggerServerEvent('esx_policejob:delete_bill', data.current.value.id)
            ESX.ShowNotification("Vous avez fait sauter l'amende " .. data.current.value.label .. " à ~g~$" .. data.current.value.amount)
          else
            ESX.ShowNotification("Cette facture ne dépends pas de vos service")
          end
        else
          TriggerEvent('Core:ShowNotification', "~r~Vous n'êtes pas autoriser à faire ceci. Contactez un Capitaine.")
        end
      end
      if data2.current.value == 'no' then
        ESX.UI.Menu.CloseAll()
      end

			menu2.close()
		  end, function(data2, menu2)
			menu2.close()
		  end)
  
		  end,
		  function(data, menu)
			  menu.close()
		  end
	  )	
  end, "police")
  
end

function police_OpenFineMenu(player)

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'pol_fine',
    {
      title    = "Amendes",
      align = 'right',
      elements = {
        {label = "Mettre une amende", value = 'billing'}
      },
    },
    function(data, menu)

      if data.current.value == 'billing' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'pol_billing',
          {
            title = "Montant invalide"
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification("Montant invalide")
            else

              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification('Aucun joueur à proximité')
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_police', 'Police', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Amendes", "**" .. GetPlayerName(PlayerId()) .. "** a amendé **"..GetPlayerName(player).."** d'un montant de `$"..amount.."`", "Yellow")
              end

            end

          end,
          function(data, menu)
            menu.close()
          end
        )
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function police_OpenCheckIdentity()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'pol_idcheck',
    {
      title    = "Vérifier une identité",
      align = 'right',
      elements = {
        {label = "Vérifier une identité", value = 'check'},
        {label = "Annuler", value = 'abort'}
      },
    },
    function(data, menu)

      if data.current.value == 'check' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'pol_idcheck',
          {
            title = "Entrer un prénom"
          },
          function(data, menu)
            local prenom = data.value

            if prenom == nil or prenom == '' then
              TriggerEvent('Core:ShowNotification', "Merci d'entrer un prénom.")
              ESX.UI.Menu.CloseAll()
            else
              menu.close()
              ESX.UI.Menu.Open(
                'dialog', GetCurrentResourceName(), 'pol_idcheckname',
                {
                  title = "Entrer un nom"
                },
                function(data2, menu2)
                  local nom = data2.value
      
                  if nom == nil or nom == '' then
                    TriggerEvent('Core:ShowNotification', "Merci d'entrer un nom.")
                    ESX.UI.Menu.CloseAll()
                  else
                    menu2.close()
                    TriggerServerEvent('esx_policejob:CheckId', prenom, nom)
                  end
      
                end,
                function(data2, menu2)
                  menu2.close()
                end
              )
            end
            menu.close()
          end,
          function(data, menu)
            menu.close()
          end
        )
      end
      if data.current.value == 'abort' then
        ESX.UI.Menu.CloseAll()
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function police_OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = Ftext_esx_policejob('fine'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config_esx_policejob.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', Ftext_esx_policejob('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', Ftext_esx_policejob('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          police_OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end
 
function police_OpenVehicleInfosMenu(vehicleData)
  if vehicleData.plate then
      TriggerServerEvent('esx_policejob:GetPlate', vehicleData.plate)
  else
    TriggerEvent('Core:ShowNotification', "Une ~r~erreur~w~ s'est produite, merci de réessayer.")
  end
end

function police_OpenGetWeaponMenu(job)

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      local check = true

      for y=1, #weapons, 1 do
        if (y ~= i and y > i) and weapons[y].name == weapons[i].name then
          check = false
          break
        end
      end

      if check and weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = Ftext_esx_policejob('get_weapon_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		
		ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
      police_OpenGetWeaponMenu(job)
		end, data.current.value, job)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, job)

end

function police_OpenPutWeaponMenu(job)

  local elements   = {}

  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPONFtext_esx_policejobNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = Ftext_esx_policejob('put_weapon_menu'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
        police_OpenPutWeaponMenu(job)
      end, data.current.value, job)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function police_OpenBuyWeaponsMenu(station, job)
    local elements = {}

    for i=1, #Config_esx_policejob.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config_esx_policejob.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = (weapon.label or ESX.GetItemLabel(weapon.name)) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = Ftext_esx_policejob('buy_weapon_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)
        local inventoryName = 'society_' .. job .. '_buy_inventory_big_fdo_weapon_buy_storage';
        ESX.TriggerServerCallback('core_inventory:custom:InventoryCanCarry', function(canCarry)
          if (canCarry) then
            ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)
              if hasEnoughMoney then
                ESX.TriggerServerCallback('core_inventory:custom:AddItemIntoInventory', function(result)
                  police_OpenBuyWeaponsMenu(station, job)
                  if job == "police" then
                    TriggerServerEvent('CoreLog:SendDiscordLog', "LSPD - Armurerie", "**" .. GetPlayerName(PlayerId()) .. "** a acheté **`"..data.current.value.."`** pour `$"..data.current.price.."`", "Yellow")
                  end
                end, inventoryName, string.lower(data.current.value), 1, data.current.price)                
              else
                TriggerEvent('Core:ShowNotification', Ftext_esx_policejob('not_enough_money'))
              end
            end, data.current.price, job)
          else
            TriggerEvent('Core:ShowNotification', 'Il n\'y a pas assez de place dans le stockage de récéption d\'achat d\'arme. Faites le vide.')
          end          
        end, inventoryName, data.current.value, 1)

      end,
      function(data, menu)
        menu.close()
      end)
end

function police_OpenGetStocksMenu(job)

  ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      local check = true 

      for y=1, #items, 1 do
        if (y ~= i and y > i) and items[y].label == items[i].label then
          check = false
          break
        end
      end

      if check and items[i].count > 0 then
        table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. (items[i].label or "NULL"), value = items[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Ftext_esx_policejob('police_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_policejob('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_policejob('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              police_OpenGetStocksMenu(job)
              TriggerServerEvent('esx_policejob:getStockItem', itemName, count, job)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, job)

end

function police_OpenPutStocksMenu(job)

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Ftext_esx_policejob('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_policejob('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_policejob('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              police_OpenPutStocksMenu()
              TriggerServerEvent('esx_policejob:putStockItems', itemName, count, job)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function police_GetVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, playerPed, 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Police',
    number     = 'police',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum, job)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = Ftext_esx_policejob('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = Ftext_esx_policejob('open_bossmenu')
    CurrentActionData = {}
  end

  if part == 'Billing' then
    CurrentAction     = 'menu_billing'
    CurrentActionMsg  = "Appuyez sur ~b~E ~s~pour consulter les factures impayées"
    CurrentActionData = {}
  end

  if part == 'IdentityCheck' then
    CurrentAction     = 'menu_identitycheck'
    CurrentActionMsg  = "Appuyez sur ~b~E ~s~pour vérifier une identitée"
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = Ftext_esx_policejob('open_armory')
    CurrentActionData = {station = station}
    CurrentJob        = job
  end

  if part == 'HelicopterSpawner' then
    local helicopters = Config_esx_policejob.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then
      CurrentAction     = 'menu_helicopter'
      CurrentActionMsg  = "Appuyez sur ~y~E~w~pour ouvrir le garage"
      CurrentActionData = {station = station, partNum = partNum, can = true}
      CurrentJob        = job
    else
      CurrentAction     = 'menu_helicopter'
      CurrentActionMsg  = "~r~Un hélicoptère est déjà sur piste."
      CurrentActionData = {station = station, partNum = partNum, can = false}
      CurrentJob        = job
    end
  end

  if part == 'VehicleDeleter' then
    if IsPedInAnyVehicle(playerPed,  false) then
      local vehicle = GetVehiclePedIsIn(playerPed, false)
      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = Ftext_esx_policejob('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end
    end
  end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.service == 1 and not IsPedInAnyVehicle(playerPed, false)) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.service == 1 and not IsPedInAnyVehicle(playerPed, false)) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = Ftext_esx_policejob('remove_object')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    
    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(heading)

  IsHandcuffed    = not IsHandcuffed;

  Citizen.CreateThread(function()

    if IsHandcuffed then
      SetEntityHeading(playerPed, heading)
      FreezeEntityPosition(playerPed, true)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, true)--changed to true
      DisableControlAction(0,21,true) -- disable sprint
      DisableControlAction(0,24,true) -- disable attack
      DisableControlAction(0,25,true) -- disable aim
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,257,true) -- disable melee
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,142,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee
      DisableControlAction(0,75,true) -- disable exit vehicle
      DisableControlAction(27,75,true) -- disable exit vehicle
      DisableControlAction(0,32,true) -- move (w)
      DisableControlAction(0,34,true) -- move (a)
      DisableControlAction(0,33,true) -- move (s)
      DisableControlAction(0,35,true) -- move (d)
      --DisableControlAction(0,73,true) -- X - OK
      Citizen.Wait(2000)
      FreezeEntityPosition(playerPed, false)
    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      DisableControlAction(0,21,false) -- disable sprint
      DisableControlAction(0,24,false) -- disable attack
      DisableControlAction(0,25,false) -- disable aim
      DisableControlAction(0,47,false) -- disable weapon
      DisableControlAction(0,58,false) -- disable weapon
      DisableControlAction(0,263,false) -- disable melee
      DisableControlAction(0,264,false) -- disable melee
      DisableControlAction(0,257,false) -- disable melee
      DisableControlAction(0,140,false) -- disable melee
      DisableControlAction(0,141,false) -- disable melee
      DisableControlAction(0,142,false) -- disable melee
      DisableControlAction(0,143,false) -- disable melee
      DisableControlAction(0,75,false) -- disable exit vehicle
      DisableControlAction(27,75,false) -- disable exit vehicle
      DisableControlAction(0,32,false) -- move (w)
      DisableControlAction(0,34,false) -- move (a)
      DisableControlAction(0,33,false) -- move (s)
      DisableControlAction(0,35,false) -- move (d)
      --DisableControlAction(0,73,false) -- X
    end

  end)
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()

  
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = coords
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(playerPed, xnew, ynew, plyPos.z)
end)

-- Handcuff
function police03()
	--Disable the spawning of NPC cops
	local myCoords = coords
    ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)
	--end Disable the spawning of NPC cops
	
    if IsHandcuffed then
        if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
          RequestAnimDict('mp_arresting')

          while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
          end

          TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end
        DisableControlAction(0,21,true) -- disable sprint
        DisableControlAction(0,24,true) -- disable attack
        DisableControlAction(0,25,true) -- disable aim
        DisableControlAction(0,47,true) -- disable weapon
        DisableControlAction(0,58,true) -- disable weapon
        DisableControlAction(0,263,true) -- disable melee
        DisableControlAction(0,264,true) -- disable melee
        DisableControlAction(0,257,true) -- disable melee
        DisableControlAction(0,140,true) -- disable melee
        DisableControlAction(0,141,true) -- disable melee
        DisableControlAction(0,142,true) -- disable melee
        DisableControlAction(0,143,true) -- disable melee
        DisableControlAction(0,75,true) -- disable exit vehicle
        DisableControlAction(27,75,true) -- disable exit vehicle
        DisableControlAction(0,32,true) -- move (w)
        DisableControlAction(0,34,true) -- move (a)
        DisableControlAction(0,33,true) -- move (s)
        DisableControlAction(0,35,true) -- move (d)
    end

    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = playerPed
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(playerPed, true, false)
      end
    end
end

-- Create blips
Citizen.CreateThread(function()

  for k,v in pairs(Config_esx_policejob.PoliceStations) do

    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

    SetBlipSprite (blip, v.Blip.Sprite)
    SetBlipDisplay(blip, v.Blip.Display)
    SetBlipScale  (blip, v.Blip.Scale)
    SetBlipColour (blip, v.Blip.Colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Ftext_esx_policejob('map_blip'))
    EndTextCommandSetBlipName(blip)
  end
end)

local tService = false

-- Display markers
function police08()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.service == 1) then
      for k,v in pairs(Config_esx_policejob.PoliceStations) do
        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_esx_policejob.DrawDistance then
            DrawMarker(Config_esx_policejob.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_policejob.MarkerColor.r, Config_esx_policejob.MarkerColor.g, Config_esx_policejob.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Billing, 1 do
          if GetDistanceBetweenCoords(coords,  v.Billing[i].x,  v.Billing[i].y,  v.Billing[i].z,  true) < Config_esx_policejob.DrawDistance then
            DrawMarker(-1, v.Billing[i].x, v.Billing[i].y, v.Billing[i].z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_policejob.MarkerColor.r, Config_esx_policejob.MarkerColor.g, Config_esx_policejob.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_policejob.DrawDistance then
            DrawMarker(Config_esx_policejob.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_policejob.MarkerColor.r, Config_esx_policejob.MarkerColor.g, Config_esx_policejob.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Helicopters, 1 do
          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config_esx_policejob.DrawDistance then
            DrawMarker(39, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config_esx_policejob.MarkerColor.r, Config_esx_policejob.MarkerColor.g, Config_esx_policejob.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config_esx_policejob.DrawDistance then
            DrawMarker(39, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
          end
        end

        if (Config_esx_policejob.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
           (Config_esx_policejob.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
            for i=1, #v.BossActions, 1 do
              if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_policejob.DrawDistance then
                DrawMarker(Config_esx_policejob.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_policejob.MarkerColor.r, Config_esx_policejob.MarkerColor.g, Config_esx_policejob.MarkerColor.b, 100, false, true, 2, false, false, false, false)
              end
            end
        end

      end

    end
end

-- Enter / Exit marker events
function police07()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.service == 1)
    or (PlayerData.job ~= nil and PlayerData.job.name == 'fib' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'fib' and PlayerData.job2.service == 1) then

      
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config_esx_policejob.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Billing, 1 do
          if GetDistanceBetweenCoords(coords,  v.Billing[i].x,  v.Billing[i].y,  v.Billing[i].z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Billing'
            currentPartNum = i
          end
        end
    
        for i=1, #v.IdentityCheck, 1 do
          if GetDistanceBetweenCoords(coords,  v.IdentityCheck[i].x,  v.IdentityCheck[i].y,  v.IdentityCheck[i].z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'IdentityCheck'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
            currentJob     = v.Armories[i].job
          end
        end

        for i=1, #v.Helicopters, 1 do

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config_esx_policejob.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if (Config_esx_policejob.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
           (Config_esx_policejob.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
          
            for i=1, #v.BossActions, 1 do
              if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_policejob.MarkerSize.x then
                isInMarker     = true
                currentStation = k
                currentPart    = 'BossActions'
                currentPartNum = i
              end
            end
          end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum
        LastJob                 = currentJob

        TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum, currentJob)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end
end

-- Enter / Exit entity zone events
function police10()
    
    local closestDistance = -1
    local closestEntity   = nil

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end
function police06()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.service == 1)
    or (PlayerData.job ~= nil and PlayerData.job.name == 'fib' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'fib' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_esx_policejob.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 2.0 then
            sleepThread = 20
			      DrawText3Ds(v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z  + 1, 'Appuyez sur ~b~E~s~ pour vous changer')
		      end
        end

        for i=1, #v.Billing, 1 do
          if GetDistanceBetweenCoords(coords,  v.Billing[i].x,  v.Billing[i].y,  v.Billing[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Billing[i].x,  v.Billing[i].y,  v.Billing[i].z  + 1, 'Appuyez sur ~b~E~s~ pour acceder au factures non payées')
		      end
        end

        for i=1, #v.IdentityCheck, 1 do
          if GetDistanceBetweenCoords(coords,  v.IdentityCheck[i].x,  v.IdentityCheck[i].y,  v.IdentityCheck[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.IdentityCheck[i].x,  v.IdentityCheck[i].y,  v.IdentityCheck[i].z  + 1, 'Appuyez sur ~b~E~s~ pour vérifier une identitée')
		      end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z  + 1, 'Appuyez sur ~b~E~s~ pour accéder à l\'armurerie/saisies')
		      end
        end

        for i=1, #v.Helicopters, 1 do
          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z + 1, 'Appuyez sur ~b~E~s~ pour sortir un hélico')
		      end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z + 1, 'Appuyez sur ~b~E~s~ pour ranger le véhicule')end
        end

        if (Config_esx_policejob.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
           (Config_esx_policejob.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
          
            for i=1, #v.BossActions, 1 do
              if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < 2.0 then
              sleepThread = 20
              DrawText3Ds(v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z + 1, 'Appuyez sur ~y~E~s~ pour ouvrir le boss menu')
            end
          end
        end

      end

    end
end

-- Key Controls
function police05()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
      if (IsControlPressed(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.service == 1 and (GetGameTimer() - GUI.Time) > 150) or 
    (IsControlPressed(0, Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'police' and PlayerData.job2.service == 1 and (GetGameTimer() - GUI.Time) > 150) or 
    (IsControlPressed(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'fib' and PlayerData.job.service == 1 and (GetGameTimer() - GUI.Time) > 150) or 
	  (IsControlPressed(0, Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'fib' and PlayerData.job2.service == 1 and (GetGameTimer() - GUI.Time) > 150) then

        if CurrentAction == 'menu_cloakroom' then
          police_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Ftext_esx_policejob('open_bossmenu')
            CurrentActionData = {}

          end)

        end 

        if CurrentAction == 'menu_billing' then
          police_OpenBillMenu()
        end

        if CurrentAction == 'menu_identitycheck' then
          police_OpenCheckIdentity()
        end

        if CurrentAction == 'menu_armory' then
          if CurrentJob == "police" then
            police_OpenArmoryMenu(CurrentActionData.station, CurrentJob)
          else
            ESX.ShowNotification("Vous n'avez pas accès ici.")
          end
        end

        if CurrentAction == 'menu_helicopter' then
          if CurrentActionData.can then
            police_OpenHeliMenu(CurrentActionData.station, CurrentActionData.partNum)
          end
        end

        if CurrentAction == 'delete_vehicle' then
		
			-- Gyrophare sur voiture civile 
			if netid then
				DetachEntity(NetToObj(netid), 1, 1)
				DeleteEntity(NetToObj(netid))
				TriggerServerEvent('copsrp_gyrophare:stopSound', playerNetVehicle)
				sirensAreActive = false
				SetVehicleRadioEnabled(playerVehicle, true)
				netid = nil
			end
			-- Gyrophare sur voiture civile 

			ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end
end

RegisterNetEvent('esx_policejob:openMenuJob')
AddEventHandler('esx_policejob:openMenuJob', function()
	police_OpenPoliceActionsMenu()
end)

RegisterNetEvent('esx_policejob:openMenuJobFib')
AddEventHandler('esx_policejob:openMenuJobFib', function()
	fib_OpenPoliceActionsMenu()
end)

RegisterNetEvent('esx_policejob:fouille')
AddEventHandler('esx_policejob:fouille', function(player)
	police_police_OpenBodySearchMenu2(player)
end)


RegisterNetEvent('esx_policejob:adminfouille')
AddEventHandler('esx_policejob:adminfouille', function(id)
	police_OpenAdminFouille(id)
end)


--how long you want the thing to last for. in seconds.
announcestring = false
lastfor = 15

--DO NOT TOUCH BELOW THIS LINE OR YOU /WILL/ FUCK SHIT UP.
--DO NOT BE STUPID AND WHINE TO ME ABOUT THIS BEING BROKEN IF YOU TOUCHED THE LINES BELOW


-- Ajout blips criminel
RegisterNetEvent('esx_policejob:resultAllCriminals')
AddEventHandler('esx_policejob:resultAllCriminals', function(array)
	allCriminals = array
end)

function enableCriminalBlips()

	for k, existingBlip in pairs(blipsCriminals) do
        RemoveBlip(existingBlip)
    end
	blipsCriminals = {}
	
	local localIdCriminals = {}
	for id = 0, 64 do
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= playerPed) then
			for i,c in pairs(allCriminals) do
				if(i == GetPlayerServerId(id)) then
					localIdCriminals[id] = c
					break
				end
			end
		end
	end
	
	for id, c in pairs(localIdCriminals) do
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)
		
		if not DoesBlipExist( blip ) then

			blip = AddBlipForEntity( ped )
			SetBlipSprite( blip, 1 )
			SetBlipColour( blip, 1 )
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			HideNumberOnBlip( blip )
			SetBlipNameToPlayerName( blip, id )
			
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )
			
			table.insert(blipsCriminals, blip)
		else
			
			blipSprite = GetBlipSprite( blip )
			
			HideNumberOnBlip( blip )
			if blipSprite ~= 1 then
				SetBlipSprite( blip, 1 )
				Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			end
			
			SetBlipNameToPlayerName( blip, id )
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )
			
			table.insert(blipsCriminals, blip)
		end
	end
end

local maxSpeed = 0
-- local minSpeed = 0
local info = ""
local isRadarPlaced = false -- bolean to get radar status
local Radar -- entity object
local RadarBlip -- blip
local RadarPos = {} -- pos
local RadarAng = 0 -- angle
local LastPlate = ""
local LastVehDesc = ""
local LastSpeed = 0
local LastInfo = ""
 
local function GetPlayers2()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end
 
local function GetClosestDrivingPlayerFromPos(radius, pos)
    local players = GetPlayers2()
    local closestDistance = radius or -1
    local closestPlayer = -1
    local closestVeh = -1
    for _ ,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local ped = GetPlayerPed(value)
            if GetVehiclePedIsUsing(ped) ~= 0 then
                local targetCoords = GetEntityCoords(ped, 0)
                local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], pos["x"], pos["y"], pos["z"], true)
                if(closestDistance == -1 or closestDistance > distance) then
                    closestVeh = GetVehiclePedIsUsing(ped)
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer, closestVeh, closestDistance
end
 
 
function radarSetSpeed(defaultText)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", 5)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local gettxt = tonumber(GetOnscreenKeyboardResult())
        if gettxt ~= nil then
            return gettxt
        else
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Veuillez entrer un nombre correct !")
            DrawSubtitleTimed(3000, 1)
            return
        end
    end
    return
end
 
 
local function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
 
function POLICE_radar()
    if isRadarPlaced then -- remove the previous radar if it exists, only one radar per cop
       
        if GetDistanceBetweenCoords(GetEntityCoords(playerPed), RadarPos.x, RadarPos.y, RadarPos.z, true) < 0.9 then -- if the player is close to his radar
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(playerPed, "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
       
            Citizen.Wait(2000) -- prevent spam radar + synchro spawn with animation time
       
            SetEntityAsMissionEntity(Radar, false, false)
           
            DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
            DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
            Radar = nil
            RadarPos = {}
            RadarAng = 0
            isRadarPlaced = false
           
            RemoveBlip(RadarBlip)
            RadarBlip = nil
            LastPlate = ""
            LastVehDesc = ""
            LastSpeed = 0
            LastInfo = ""
           
        else
           
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Vous n'êtes pas à coté de votre Radar !")
            DrawSubtitleTimed(3000, 1)
           
            Citizen.Wait(1500) -- prevent spam radar
       
        end
   
    else -- or place a new one
        maxSpeed = radarSetSpeed("50")
       
        Citizen.Wait(200) -- wait if the player was in moving
        RadarPos = GetOffsetFromEntityInWorldCoords(playerPed, 0, 1.5, 0)
        RadarAng = GetEntityRotation(playerPed)
       
        if maxSpeed ~= nil then -- maxSpeed = nil only if the player hasn't entered a valid number
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(playerPed, "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
           
            Citizen.Wait(1500) -- prevent spam radar placement + synchro spawn with animation time
           
            RequestModel("prop_cctv_pole_01a")
            while not HasModelLoaded("prop_cctv_pole_01a") do
               Wait(1)
            end
           
            Radar = CreateObject(1927491455, RadarPos.x, RadarPos.y, RadarPos.z - 7, true, true, true) -- http://gtan.codeshock.hu/objects/index.php?page=1&search=prop_cctv_pole_01a
            SetEntityRotation(Radar, RadarAng.x, RadarAng.y, RadarAng.z - 115)
            -- SetEntityInvincible(Radar, true) -- doesn't work, radar still destroyable
            -- PlaceObjectOnGroundProperly(Radar) -- useless
            SetEntityAsMissionEntity(Radar, true, true)
           
            FreezeEntityPosition(Radar, true) -- set the radar invincible (yeah, SetEntityInvincible just not works, okay FiveM.)
 
            isRadarPlaced = true
           
            RadarBlip = AddBlipForCoord(RadarPos.x, RadarPos.y, RadarPos.z)
            SetBlipSprite(RadarBlip, 380) -- 184 = cam
            SetBlipColour(RadarBlip, 1) -- https://github.com/Konijima/WikiFive/wiki/Blip-Colors
            SetBlipAsShortRange(RadarBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Radar")
            EndTextCommandSetBlipName(RadarBlip)
       
        end
       
    end
end
 
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isRadarPlaced then
       
            if HasObjectBeenBroken(Radar) then -- check is the radar is still there
               
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
                DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
            end
           
            if GetDistanceBetweenCoords(GetEntityCoords(playerPed), RadarPos.x, RadarPos.y, RadarPos.z, true) > 100 then -- if the player is too far from his radar
           
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
                DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
                ClearPrints()
                SetTextEntry_2("STRING")
                AddTextComponentString("~r~Vous êtes parti trop loin de votre Radar !")
                DrawSubtitleTimed(3000, 1)
               
            end
           
        end
       
        if isRadarPlaced then
 
            local viewAngle = GetOffsetFromEntityInWorldCoords(Radar, -8.0, -4.4, 0.0) -- forwarding the camera angle, to increase or reduce the distance, just make a cross product like this one :  ( X * 11.0 ) / 20.0 = Y   gives  (Radar, X, Y, 0.0)
            local ply, veh, dist = GetClosestDrivingPlayerFromPos(20, viewAngle) -- viewAngle
 
            -- local debuginfo = string.format("%s ~n~%s ~n~%s ~n~", ply, veh, dist)
            -- drawTxt(0.27, 0.1, 0.185, 0.206, 0.40, debuginfo, 255, 255, 255, 255)
 
            if veh ~= nil then
           
                local vehPlate = GetVehicleNumberPlateText(veh) or ""
                local vehSpeedKm = GetEntitySpeed(veh)*3.6
                local vehDesc = GetDisplayNameFromVehicleModel(GetEntityModel(veh))--.." "..GetVehicleColor(veh)
                if vehDesc == "CARNOTFOUND" then vehDesc = "" end
               
                -- local vehSpeedMph= GetEntitySpeed(veh)*2.236936
                -- if vehSpeedKm > minSpeed then            
                     
                if vehSpeedKm < maxSpeed then
                    info = string.format("~b~Véhicule  ~w~ %s ~n~~b~Plaque    ~w~ %s ~n~~y~Km/h        ~g~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                else
                    info = string.format("~b~Véhicule  ~w~ %s ~n~~b~Plaque    ~w~ %s ~n~~y~Km/h        ~r~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                    if LastPlate ~= vehPlate then
                        LastSpeed = vehSpeedKm
                        LastVehDesc = vehDesc
                        LastPlate = vehPlate
                    elseif LastSpeed < vehSpeedKm and LastPlate == vehPlate then
                            LastSpeed = vehSpeedKm
                    end
                    LastInfo = string.format("~b~Véhicule  ~w~ %s ~n~~b~Plaque    ~w~ %s ~n~~y~Km/h        ~r~%s", LastVehDesc, LastPlate, math.ceil(LastSpeed))
                end
                   
				DrawRect(0.76, 0, 0.185, 0.38, 204, 204, 204, 210)   
				   
                DrawRect(0.76, 0.0455, 0.18, 0.09, 255, 255, 255, 180)
                drawTxt(0.77, 0.1, 0.185, 0.206, 0.40, info, 255, 255, 255, 255)
               
                DrawRect(0.76, 0.140, 0.18, 0.09, 255, 255, 255, 180)
                drawTxt(0.77, 0.20, 0.185, 0.206, 0.40, LastInfo, 255, 255, 255, 255)
                 
                -- end
               
            end
           
        end
    end  
end)

------------------------------------------------------------------------------
--------------SOUS SOLS
------------------------------------------------------------------------------

RegisterNetEvent('police:deployRadar')
AddEventHandler('police:deployRadar', function()
	POLICE_radar()
end)

-- Gyrophare sur voiture civile -- DEBUT
RegisterNetEvent("copsrp_gyrophare:toggleBeacon")
AddEventHandler("copsrp_gyrophare:toggleBeacon", function()
	local playerJob 	= PlayerData.job.name
	local playerCoords 	= coords
	local lightSpawned 	= nil

	if playerJob ~= 'police' and playerJob ~= 'sheriff' and playerJob ~= 'fib' then
		return TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Vous n\'etes pas policier.' } }) 
	end
	
	if IsPedInAnyVehicle(playerPed) then
		if not netid then
			playerVehicle 		= GetVehiclePedIsIn(playerPed, false)
			playerNetVehicle 	= VehToNet(playerVehicle)
			playerVehicleClass 	= GetVehicleClass(playerVehicle)
			
			-- Making sure it is not used in the wrong vehicles
			if playerVehicleClass > 7 then
				return TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Mauvais type de vehicule' } }) 
			end
			
			RequestModel(GetHashKey(lightModel))
			while not HasModelLoaded(GetHashKey(lightModel)) do Citizen.Wait(0) end
			lightSpawned = CreateObject(GetHashKey(lightModel), playerCoords.x, playerCoords.y, playerCoords.z, 1, 1, 1)
			Citizen.Wait(1000)
			netid = ObjToNet(lightSpawned)
			if playerJob == "sheriff" then 
				TriggerEvent("nebularp_gyrophare_sheriff:delveh", netid)
			end
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			
			AttachEntityToEntity(lightSpawned, playerVehicle, GetEntityBoneIndexByName(playerVehicle, "windscreen"), 0.35, -0.5, 0.2, 90.0, 180.0, 10.0, 1, 0, 0, 1, 0, 1)
			SetVehicleRadioEnabled(playerVehicle, false)
			ESX.ShowNotification("Gyrophare posé")
		else
			DetachEntity(NetToObj(netid), 1, 1)
			DeleteEntity(NetToObj(netid))
			TriggerServerEvent('copsrp_gyrophare:stopSound', playerNetVehicle)
			sirensAreActive = false
			SetVehicleRadioEnabled(playerVehicle, true)
			netid = nil
			ESX.ShowNotification("Gyrophare retiré")
		end
	end
end)

function police04()
		if netid then
			-- Toggle siren
			if IsControlJustReleased(0, 82) then
				if sirensAreActive then
					TriggerServerEvent('copsrp_gyrophare:stopSound', playerNetVehicle)
					sirensAreActive = false
				else
					currentSiren = 1
					TriggerServerEvent('copsrp_gyrophare:triggerSound', "VEHICLES_HORNS_SIREN_" .. currentSiren, playerNetVehicle)
					sirensAreActive = true
				end
			end
			
			-- Change siren tone
			if IsControlJustReleased(0, 81) and sirensAreActive then
				currentSiren = currentSiren + 1 
				if currentSiren == 3 then
					currentSiren = 0
					TriggerServerEvent('copsrp_gyrophare:triggerSound', "VEHICLES_HORNS_POLICE_WARNING", playerNetVehicle)
				else
					TriggerServerEvent('copsrp_gyrophare:triggerSound', "VEHICLES_HORNS_SIREN_" .. currentSiren, playerNetVehicle)
				end
			end
			
		end
end

RegisterNetEvent('copsrp_gyrophare:triggerSound')
AddEventHandler('copsrp_gyrophare:triggerSound', function(soundName, vehicle, soundId)
	PlaySoundFromEntity(soundId, soundName, NetToVeh(vehicle), 0, 0, 0)
end)

RegisterNetEvent('copsrp_gyrophare:stopSound')
AddEventHandler('copsrp_gyrophare:stopSound', function(soundId, vehicle)
	PlaySoundFromEntity(soundId, "SUSPENSION_SCRIPT_FORCE", NetToVeh(vehicle), 0, 0, 0) -- Trick : playing a short song of the vehicle library
end)
-- Gyrophare sur voiture civile -- FIN 

function teleport(coordinate, rotate)

    DoScreenFadeOut(500)
    while IsScreenFadingOut() do Citizen.Wait(0) end
    NetworkFadeOutEntity(playerPed, true, false)
    Wait(1000)
    SetEntityCoords(playerPed, coordinate[1], coordinate[2], coordinate[3])
    NetworkFadeOutEntity(playerPed, true, false)
    NetworkFadeInEntity(playerPed, 0)
    SetEntityHeading(playerPed, coordinate[4])
    Wait(1000)
    DoScreenFadeIn(1000)
	
end

Citizen.CreateThread(function()
  while true do
      if shieldActive then
          local ped = playerPed
          if not IsEntityPlayingAnim(ped, animDictBouclier, animName, 1) then
              RequestAnimDict(animDictBouclier)
              while not HasAnimDictLoaded(animDictBouclier) do
                  Citizen.Wait(100)
              end
          
              TaskPlayAnim(ped, animDictBouclier, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
          end
      end
      Citizen.Wait(250)
  end
end)