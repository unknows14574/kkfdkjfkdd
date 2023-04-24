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

function Ftext_esx_sheriff(txt)
	return Config_esx_sheriff.Txt[txt]
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
local netid 					= nil

zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

GUI.Time                        = 0


function sheriff_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 4,
    modBrakes       = 3,
    modTransmission = 4,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function sheriff_SetWindowTint(vehicle)

  local props = {
    windowTint       = 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function sheriff_EnableShield()
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

function sheriff_DisableShield()
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

function sheriff_OpenAccessoiresMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Accessoires_menu',
    {
      title    = "Accessoires",
      align = 'right',
      elements = {
    {label = "Mettre gilet pare-balles léger", value = 'gilet1_put'},
    {label = "Mettre gilet pare-balles normal", value = 'gilet2_put'},
    {label = "Mettre gilet pare-balles léger SWAT", value = 'giletl2_put'},
    {label = "Mettre gilet pare-balles lourd", value = 'giletl4_put'},
    {label = "Mettre gilet pare-balles négociateur", value = 'gilet4_put'},
    {label = "Mettre l'imperméable", value = 'veste_put'},
    {label = 'Retirer le gilet pare-balle', value = 'gilet_remove'},
    {label = "Retirer l'imperméable", value = 'veste_remove'},
		{label = "Mettre Oreillette", value = 'Oreillette_put'},
		{label = "Retirer Oreillette", value = 'Oreillette_remove'},
    {label = "Mettre Chapeau", value = 'Chapeau_put'},
    {label = "Mettre Chapeau - Gradés", value = 'Chapeau2_put'},
		{label = "Retirer Chapeau", value = 'Chapeau_remove'},
		{label = "Mettre Bonnet", value = 'Bonnet_put'},
		{label = "Retirer Bonnet", value = 'Bonnet_remove'},
		{label = "Mettre Casque", value = 'Casque_put'},
		{label = "Retirer Casque", value = 'Casque_remove'},
		{label = 'Mettre Masque', value = 'Masque_put'},
    {label = 'Retirer Masque', value = 'Masque_remove'},
    {label = 'Prendre Bouclier', value = 'bouclier_give'},
    {label = 'Poser Bouclier', value = 'bouclier_remove'}
      },
    },
    function(data, menu)

    if data.current.value == 'bouclier_give' then
      sheriff_EnableShield()
    end
    
    if data.current.value == 'bouclier_remove' then
      sheriff_DisableShield()
    end

    if data.current.value == 'gilet1_put' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
  
          local clothesSkin = {
            ['bproof_1'] = 18, ['bproof_2'] = 2
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
  
          local clothesSkin = {
            ['bproof_1'] = 22, ['bproof_2'] = 3
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end	
      end)
      SetPedArmour(playerPed, 35)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'giletl4_put' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
  
          local clothesSkin = {
            ['bproof_1'] = 16, ['bproof_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
  
          local clothesSkin = {
            ['bproof_1'] = 18, ['bproof_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end	
      end)
      SetPedArmour(playerPed, 150)
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
      SetPedArmour(playerPed, 50)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end
  
    if data.current.value == 'gilet2_put' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
  
          local clothesSkin = {
            ['bproof_1'] = 12, ['bproof_2'] = 1
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
  
          local clothesSkin = {
            ['bproof_1'] = 11, ['bproof_2'] = 2
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end	
      end)
      SetPedArmour(playerPed, 50)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'gilet3_put' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
  
          local clothesSkin = {
            ['bproof_1'] = 12, ['bproof_2'] = 4
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
  
          local clothesSkin = {
            ['bproof_1'] = 11, ['bproof_2'] = 4
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end	
      end)
      SetPedArmour(playerPed, 50)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end

    if data.current.value == 'gilet4_put' then
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
      SetPedArmour(playerPed, 50)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end
  
    if data.current.value == 'gilet_remove' then
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

    if data.current.value == 'veste_put' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
  
          local clothesSkin = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 217,   ['torso_2'] = 9,
            ['decals_1'] = -1,   ['decals_2'] = 0,
            ['arms'] = 44,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
  
          local clothesSkin = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 190,   ['torso_2'] = 7,
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
            ['torso_1'] = 190,   ['torso_2'] = 2,
            ['arms'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
  
          local clothesSkin = {
            ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
            ['torso_1'] = 192,   ['torso_2'] = 2,
            ['arms'] = 14,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end	
      end)
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
	if data.current.value == 'Oreillette_remove' then
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
	
	if data.current.value == 'Chapeau_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 13, ['helmet_2'] = 3
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 13, ['helmet_2'] = 3
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end
	if data.current.value == 'Chapeau2_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 13, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 13, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	if data.current.value == 'Chapeau_remove' then
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
	
	if data.current.value == 'Bonnet_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 5, ['helmet_2'] = 0
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
	if data.current.value == 'Bonnet_remove' then
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
	
	if data.current.value == 'Casque_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 125, ['helmet_2'] = 18
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
	  
	if data.current.value == 'Masque_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = 52, ['mask_2'] = 0
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

function sheriff_OpenCloakroomMenu()

  local elements = {}

  table.insert(elements, {label = "Tenue Civil", value = 'garde_robe'})
  table.insert(elements, {label = "Tenue Sheriff", value = 'sheriff_wear'})
  table.insert(elements, {label = "Tenue SRT", value = 'give_tenu'})
  table.insert(elements, {label = "Tenue pilote Henry", value = 'helico_wear'})
  table.insert(elements, {label = "Tenue pilote Mary", value = 'mary_wear'})
  table.insert(elements, {label = "Tenue K9 Unit", value = 'k9_wear'})
  table.insert(elements, {label = "Tenue HEAT", value = 'heat_wear'})
  table.insert(elements, {label = "Tenue Cérémoniale", value = 'cere_wear'})

  
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom1',
    {
      title    = "Vestiaire",
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

	  if data.current.value == 'sheriff_wear' then --sheriff standard
      TriggerServerEvent("player:serviceOn", "sheriff")
      if (PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.service == 1) then
        if (PlayerData.job.grade_name == "rce") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                local clothesSkin = {
                  ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                  ['torso_1'] = 190,   ['torso_2'] = 2,
                  ['decals_1'] = 0,   ['decals_2'] = 0,
                  ['bproof_1'] = 13, ['bproof_2'] = 0,
                  ['arms'] = 0,
                  ['mask_1'] = -1, ['mask_2'] = 0,
                  ['pants_1'] = 59,   ['pants_2'] = 1,
                  ['shoes_1'] = 24,   ['shoes_2'] = 0,
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = -1,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0, 
                  ['glasses_1'] = -1,  ['glasses_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
                local clothesSkin = {
                  ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                  ['torso_1'] = 192,   ['torso_2'] = 2,
                  ['decals_1'] = 0,   ['decals_2'] = 0,
                  ['bproof_1'] = 18, ['bproof_2'] = 0,
                  ['arms'] = 14,
                  ['mask_1'] = -1, ['mask_2'] = 0,
                  ['pants_1'] = 61,   ['pants_2'] = 1,
                  ['shoes_1'] = 24,   ['shoes_2'] = 0,
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = -1,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0,
                  ['glasses_1'] = -1,  ['glasses_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "cds") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 2,
                ['decals_1'] = 115,   ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 2,
                ['decals_1'] = 115,   ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "cdd") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 2,
                ['decals_1'] = 115,   ['decals_2'] = 1,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 2,
                ['decals_1'] = 115,   ['decals_2'] = 1,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "ast") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 2,
                ['decals_1'] = 115,   ['decals_2'] = 2,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 2,
                ['decals_1'] = 115,   ['decals_2'] = 2,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "adj") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 2,
                ['decals_1'] = 44,   ['decals_2'] = 6,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 2,
                ['decals_1'] = 52,   ['decals_2'] = 6,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "cpt") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 2,
                ['decals_1'] = 44,   ['decals_2'] = 7,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 2,
                ['decals_1'] = 52,   ['decals_2'] = 7,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "sadj") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 94,   ['torso_2'] = 1,
                ['decals_1'] = 44,   ['decals_2'] = 8,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 85,   ['torso_2'] = 1,
                ['decals_1'] = 52,   ['decals_2'] = 8,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 1,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "coboss") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 3,
                ['decals_1'] = 44,   ['decals_2'] = 9,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 0,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 3,
                ['decals_1'] = 52,   ['decals_2'] = 9,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 0,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
          end)
        elseif (PlayerData.job.grade_name == "boss") then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
              local clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
                ['torso_1'] = 190,   ['torso_2'] = 3,
                ['decals_1'] = 44,   ['decals_2'] = 10,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 59,   ['pants_2'] = 0,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0, 
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
              local clothesSkin = {
                ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
                ['torso_1'] = 192,   ['torso_2'] = 3,
                ['decals_1'] = 52,   ['decals_2'] = 10,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 14,
                ['mask_1'] = -1, ['mask_2'] = 0,
                ['pants_1'] = 61,   ['pants_2'] = 0,
                ['shoes_1'] = 24,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 8,    ['chain_2'] = 0,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = -1,  ['glasses_2'] = 0,
                ['bags_1'] = 53, ['bags_2'] = 0
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
    end
    
    if data.current.value == 'give_tenu' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 16,  ['tshirt_2'] = 0,
            ['torso_1'] = 49,   ['torso_2'] = 2,
            ['decals_1'] = 4,   ['decals_2'] = 0,
            ['bproof_1'] = 16, ['bproof_2'] = 1,
            ['mask_1'] = 52,   ['mask_2'] = 0,
            ['arms'] = 50,
            ['pants_1'] = 31,   ['pants_2'] = 2,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 75,  ['helmet_2'] = 0,
            ['chain_1'] = 42,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = 45, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 9,  ['tshirt_2'] = 0,
            ['torso_1'] = 42,   ['torso_2'] = 2,
            ['decals_1'] = 4,   ['decals_2'] = 0,
            ['bproof_1'] = 18, ['bproof_2'] = 0,
            ['mask_1'] = 52,   ['mask_2'] = 0,
            ['arms'] = 31,
            ['pants_1'] = 30,   ['pants_2'] = 2,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 74,  ['helmet_2'] = 0,
            ['chain_1'] = 29,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['bags_1'] = 45, ['bags_2'] = 0
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
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 228,   ['torso_2'] = 4,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 17,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 92,   ['pants_2'] = 4,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 79,  ['helmet_2'] = 2,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0, 
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 238,   ['torso_2'] = 4,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 18,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 95,   ['pants_2'] = 4,
            ['shoes_1'] = 25,   ['shoes_2'] = 0,
            ['helmet_1'] = 77,  ['helmet_2'] = 2,
            ['glasses_1'] = 5,  ['glasses_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
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

    if data.current.value == 'mary_wear' then
      TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
          local clothesSkin = {
            ['tshirt_1'] = 38,  ['tshirt_2'] = 0,
            ['torso_1'] = 152,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 17,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 67,   ['pants_2'] = 10,
            ['shoes_1'] = 46,   ['shoes_2'] = 3,
            ['helmet_1'] = 16,  ['helmet_2'] = 1,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = 25,  ['glasses_2'] = 4,
            ['bags_1'] = 0, ['bags_2'] = 0, 
            ['chain_1'] = 8,    ['chain_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 27,  ['tshirt_2'] = 0,
            ['torso_1'] = 149,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 18,
            ['pants_1'] = 79,   ['pants_2'] = 10,
            ['shoes_1'] = 47,   ['shoes_2'] = 3,
            ['helmet_1'] = 16,  ['helmet_2'] = 1,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['glasses_1'] = 27,  ['glasses_2'] = 4,
            ['bags_1'] = 0, ['bags_2'] = 0, 
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
            ['torso_1'] = 94,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 12, ['bproof_2'] = 0,
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
            ['torso_1'] = 192,   ['torso_2'] = 7,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 11, ['bproof_2'] = 1,
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
            ['helmet_1'] = 13,  ['helmet_2'] = 2,
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
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 61,   ['pants_2'] = 0,
            ['shoes_1'] = 24,   ['shoes_2'] = 0,
            ['helmet_1'] = 13,  ['helmet_2'] = 2,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0, 
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
            ['torso_1'] = 200,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['arms'] = 75,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 50,   ['pants_2'] = 3,
            ['shoes_1'] = 54,   ['shoes_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['chain_1'] = 13,     ['chain_2'] = 0,
            ['glasses_1'] = -1,  ['glasses_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0
          }
          TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
          local clothesSkin = {
            ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
            ['torso_1'] = 202,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['arms'] = 88,
            ['mask_1'] = -1, ['mask_2'] = 0,
            ['pants_1'] = 23,   ['pants_2'] = 0,
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
      CurrentActionMsg  = Ftext_esx_sheriff('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_sheriff('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function sheriff_OpenArmoryMenu(station)

  if Config_esx_sheriff.EnableArmoryManagement then

    local elements = {
      --{label = 'Prendre un tracker gps sheriff',  value = 'gps_sheriff'},
      --{label = 'Prendre un bracelet électronique',  value = 'belectro'},
      --{label = 'Prendre un gilet pare-balle',  value = 'gilet_wear'},
      --{label = 'Enlever le gilet pare-balle',  value = 'veste_wear'},
      {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
      {label = 'Ouvrir le stockage', value = 'get_stock'},
      {label = 'Déposer Argent (cash)',  value = 'put_money'},
      {label = 'Déposer Argent (sale)',  value = 'put_blackmoney'}
    }
	
	if PlayerData.job.grade_name == 'boss' or PlayerData.job2.grade_name == 'boss' then
      table.insert(elements, {label = 'Retirer Argent (cash)', value = 'get_money'})
	    table.insert(elements, {label = 'Retirer Argent (sale)', value = 'get_blackmoney'})
      table.insert(elements, {label = 'Acheter armes', value = 'buy_weapons'})
      table.insert(elements, {label = 'Ouvrir récéption achat d\'arme', value = 'get_weapon_buy'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = Ftext_esx_sheriff('armory'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)
	  
		if data.current.value == 'gps_sheriff' then
			TriggerServerEvent('gps:itemadd', "braceletgps2")
		end
		if data.current.value == 'belectro' then
			TriggerServerEvent('gps:itemadd', "braceletgps")
		end

		if data.current.value == 'put_money' then
				ESX.TriggerServerCallback('esx_sheriff:CheckMoney', function (_money)
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
								TriggerServerEvent('esx_sheriff:putmoney', amount)
							end
		
						end, function(data, menu)
							menu.close()
						end)
					end)
		end
	  
		if data.current.value == 'get_money' then
				ESX.TriggerServerCallback('esx_sheriff:CheckMoney', function (_money)
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
							TriggerServerEvent('esx_sheriff:getmoney', amount)
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)

		end

		if data.current.value == 'put_blackmoney' then
				ESX.TriggerServerCallback('esx_sheriff:CheckBlackMoney', function (_blackmoney)
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
							TriggerServerEvent('esx_sheriff:putblackmoney', amount, blackmoney)
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)
		end
		if data.current.value == 'get_blackmoney' then
				ESX.TriggerServerCallback('esx_sheriff:CheckBlackMoney', function (_blackmoney)
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
							TriggerServerEvent('esx_sheriff:getblackmoney', amount, blackmoney)
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)
		end

    if data.current.value == 'buy_weapons' then
      ESX.TriggerServerCallback('esx_sheriff:checkIfArmoryStorageOpenOneTime', function(oneTimeOpen)
        if (oneTimeOpen) then
          sheriff_OpenBuyWeaponsMenu(station)
        else
          TriggerEvent('Core:ShowNotification', "Vérifiez d'abord la récéption d'achat d'arme")
        end          
      end)
    end
    if data.current.value == 'get_weapon' then
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventoryName', 'society_sheriff', 'big_fdo_weapons_storage')
      menu.close()
    end
    if data.current.value == 'get_weapon_buy' then
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventoryName', 'society_sheriff', 'big_fdo_weapons_storage')
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventoryName', 'society_sheriff_buy_inventory', 'big_fdo_weapon_buy_storage')
    end
    if data.current.value == 'get_stock' then
      TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_sheriff')
      menu.close()
    end
			
		if data.current.value == 'gilet_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()

          SetPedArmour(playerPed, 50)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
          end)
        end
	  
	    if data.current.value == 'veste_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()

          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
          end)
        end			

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = Ftext_esx_sheriff('open_armory')
        CurrentActionData = {station = station}
      end
    )

  else

    local elements = {}

    for i=1, #Config_esx_sheriff.BCSStations[station].AuthorizedWeapons, 1 do
      local weapon = Config_esx_sheriff.BCSStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetWeaponName(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = Ftext_esx_sheriff('armory'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_sheriff:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = Ftext_esx_sheriff('open_armory')
        CurrentActionData = {station = station}

      end
    )

  end

end

function sheriff_OpenVehicleVSpawnerMenu(station, partNum)

  local vehicles = Config_esx_sheriff.BCSStations[station].VehiclesV

  ESX.UI.Menu.CloseAll()

  if Config_esx_sheriff.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawnerv',
        {
          title    = Ftext_esx_sheriff('vehicle_menu'),
          align = 'right',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

            TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'sheriff', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawnerv'
          CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'sheriff')

  else

    local elements = {}

    table.insert(elements, { label = 'ATV (quad)', value = 'atvpd'})
	table.insert(elements, { label = 'Moto', value = 'policeb'})

	table.insert(elements, { label = 'Sheriff', value = 'sheriff'})
	table.insert(elements, { label = 'Sheriff SUV', value = 'sheriff2'})
	table.insert(elements, { label = 'Dodge Charger', value = 'chargersheriff'})
	table.insert(elements, { label = 'Chevrolet Tahoe (SUV)', value = 'tahoesheriff'})
	
	table.insert(elements, { label = 'Sandking', value = 'sandkingshf'})
	table.insert(elements, { label = 'Chevry Surban', value = 'chevrysurban'})
	--table.insert(elements, { label = 'Audi RS4', value = 'rs4shf'})
	table.insert(elements, { label = 'Ford Interceptor', value = 'intershf'})
	table.insert(elements, { label = 'Ford Explorer', value = 'expshf'})
	--table.insert(elements, { label = 'Lamborghini Aventador', value = 'lamboshf'})
	--table.insert(elements, { label = 'McLaren 650s', value = 'mclarenshf'})
	table.insert(elements, { label = 'Insurgent', value = 'policeinsurgent'})
	table.insert(elements, { label = 'Riot', value = 'riotshf'})
	
	table.insert(elements, { label = 'Voiture Banalisée', value = 'police4'})
	table.insert(elements, { label = 'Suv FIB', value = 'fbi2'})	
	table.insert(elements, { label = 'Buffalo FIB', value = 'fbi'})
	--table.insert(elements, { label = 'Jackal Banalisée', value = 'jackal2'})
  table.insert(elements, { label = 'Dodge Charger Banalisée', value = 'chargerpd'})
  --table.insert(elements, { label = 'Mustang GT', value = '2015polstang'})
	--table.insert(elements, { label = 'Adder Banalisée', value = 'adder2'})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawnerv',
      {
        title    = Ftext_esx_sheriff('vehicle_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          if Config_esx_sheriff.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              sheriff_SetVehicleMaxMods(vehicle)
			  
			  --if model == 'rs4shf' or model == 'chevrysurban' or model == 'chargersheriff' then
				--lol
			  --else
				--sheriff_SetWindowTint(vehicle)
			  --end

			  if model == 'police44' then 
				SetVehicleColours(vehicle, 12, 12)
        end
        if model == '2015polstang' then 
          SetVehicleLivery(vehicle, 3) 
        end
		if model == 'atvpd' then 
          SetVehicleFuelLevel(vehicle, 100)
          exports['Nebula_Fuel']:SetFuel(vehicle, 100.0) 
        end
		if model == 'policeb' then 
          SetVehicleLivery(vehicle, 1) 
        end
        
        if model == 'chargerpd' then
          SetVehicleLivery(vehicle, 1) 
        end

              local rand = math.random(1,9)
             SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
             SetVehicleFuelLevel(vehicle, 100.0)
             exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
				TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  sheriff_SetVehicleMaxMods(vehicle)
                  sheriff_SetWindowTint(vehicle)
				  
				  if model == 'police44' then 
					SetVehicleColours(vehicle, 12, 12)
				  end

                  local rand = math.random(1,9)
                  SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
                  SetVehicleFuelLevel(vehicle, 100.0)
                  exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
						TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
                end)

              else
                ESX.ShowNotification(Ftext_esx_sheriff('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'sheriff')

          end

        else
          ESX.ShowNotification(Ftext_esx_sheriff('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawnerv'
        CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum}

      end
    )

  end

end

function sheriff_OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config_esx_sheriff.BCSStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config_esx_sheriff.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = Ftext_esx_sheriff('vehicle_menu'),
          align = 'right',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

            TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'sheriff', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'sheriff')

  else

    local elements = {}

    table.insert(elements, { label = 'ATV (quad)', value = 'atvpd'})

    table.insert(elements, { label = 'Sheriff', value = 'sheriff'})
    table.insert(elements, { label = 'Sheriff SUV', value = 'sheriff2'})
    table.insert(elements, { label = 'Dodge Charger', value = 'chargersheriff'})
    table.insert(elements, { label = 'Chevrolet Tahoe (SUV)', value = 'tahoesheriff'})
    
    table.insert(elements, { label = 'Sandking', value = 'sandkingshf'})
    table.insert(elements, { label = 'Chevry Surban', value = 'chevrysurban'})
    --table.insert(elements, { label = 'Audi RS4', value = 'rs4shf'})
    table.insert(elements, { label = 'Ford Interceptor', value = 'intershf'})
    table.insert(elements, { label = 'Ford Explorer', value = 'expshf'})
    --table.insert(elements, { label = 'Lamborghini Aventador', value = 'lamboshf'})
    --table.insert(elements, { label = 'McLaren 650s', value = 'mclarenshf'})
    table.insert(elements, { label = 'Insurgent', value = 'policeinsurgent'})
    table.insert(elements, { label = 'Riot', value = 'riotshf'})
    
    table.insert(elements, { label = 'Voiture Banalisée', value = 'police4'})
    table.insert(elements, { label = 'Suv FIB', value = 'fbi2'})	
    table.insert(elements, { label = 'Buffalo FIB', value = 'fbi'})
    --table.insert(elements, { label = 'Jackal Banalisée', value = 'jackal2'})
    table.insert(elements, { label = 'Dodge Charger Banalisée', value = 'chargerpd'})
    --table.insert(elements, { label = 'Mustang GT', value = '2015polstang'})
    --table.insert(elements, { label = 'Adder Banalisée', value = 'adder2'})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = Ftext_esx_sheriff('vehicle_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          if Config_esx_sheriff.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              sheriff_SetVehicleMaxMods(vehicle)
			  
			  --if model == 'rs4shf' or model == 'chevrysurban' or model == 'chargersheriff' then
				--lol
			  --else
				--sheriff_SetWindowTint(vehicle)
			  --end

			  if model == 'police44' then 
				SetVehicleColours(vehicle, 12, 12)
        end
        if model == '2015polstang' then 
          SetVehicleLivery(vehicle, 3) 
        end
        if model == 'chargerpd' then
          SetVehicleLivery(vehicle, 1) 
        end

              local rand = math.random(1,9)
              SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
              SetVehicleFuelLevel(vehicle, 100.0)
              exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
					TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  sheriff_SetVehicleMaxMods(vehicle)
                  sheriff_SetWindowTint(vehicle)
				  
				  if model == 'police44' then 
					SetVehicleColours(vehicle, 12, 12)
				  end

                  local rand = math.random(1,9)
                  SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
                  SetVehicleFuelLevel(vehicle, 100.0)
                  exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
						TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
                end)

              else
                ESX.ShowNotification(Ftext_esx_sheriff('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'sheriff')

          end

        else
          ESX.ShowNotification(Ftext_esx_sheriff('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum}

      end
    )

  end

end

function sheriff_OpenVehicle1VSpawnerMenu(station, partNum)

	local vehicles1 = Config_esx_sheriff.BCSStations[station].HelicoPaleto

	ESX.UI.Menu.CloseAll()

	if Config_esx_sheriff.EnableSocietyOwnedVehicles1 then

    local elements = {}      

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles1)

			for i=1, #garageVehicles1, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles1[i].model) .. ' [' .. garageVehicles1[i].plate .. ']', value = garageVehicles1[i]})
			end

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'vehicle_spawner1',
				{
					title    = Ftext_esx_sheriff('vehicle_menu'),
					align = 'right',
					elements = elements,
				},
				function(data, menu)

					menu.close()

					local vehicleProps = data.current.value

          helico = ESX.Game.SpawnVehicle(vehicleProps.model, vehicles1[partNum].SpawnPoint1, 270.0, function(vehicle)

					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
		
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          
				end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'sheriff', vehicleProps)

				end,
				function(data, menu)

					menu.close()

					CurrentAction     = 'menu_vehicle_spawner1v'
					CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end
			)

		end, 'sheriff')

	else

		local elements = {}

		for i=1, #Config_esx_sheriff.BCSStations[station].AuthorizedVehicles1, 1 do
			local vehicle = Config_esx_sheriff.BCSStations[station].AuthorizedVehicles1[i]
			table.insert(elements, {label = vehicle.label, value = vehicle.name})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_spawner1v',
			{
				title    = Ftext_esx_sheriff('vehicle_menu'),
				align = 'right',
				elements = elements,
			},
			function(data, menu)

				menu.close()

				local model = data.current.value

				local vehicle = GetClosestVehicle(vehicles1[partNum].SpawnPoint1.x,  vehicles1[partNum].SpawnPoint1.y,  vehicles1[partNum].SpawnPoint1.z,  3.0,  0,  71)

				if not DoesEntityExist(vehicle) then

		
					if Config_esx_sheriff.MaxInService == -1 then

						ESX.Game.SpawnVehicle(model, {
							x = vehicles1[partNum].SpawnPoint1.x, 
							y = vehicles1[partNum].SpawnPoint1.y, 
							z = vehicles1[partNum].SpawnPoint1.z
						}, vehicles1[partNum].Heading1, function(vehicle)
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              sheriff_SetVehicleMaxMods(vehicle)
              --sheriff_SetWindowTint(vehicle)

              SetVehicleModKit(vehicle, 0)
							SetVehicleLivery(vehicle, 1)

						local rand = math.random(1,9)
                  SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
                  SetVehicleFuelLevel(vehicle, 100.0)
                  exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
						TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
						end)

					else

						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

							if canTakeService then

								ESX.Game.SpawnVehicle(model, {
									x = vehicles1[partNum].SpawnPoint1.x, 
									y = vehicles1[partNum].SpawnPoint1.y, 
									z = vehicles1[partNum].SpawnPoint1.z
								}, Vehicles1[partNum].Heading, function(vehicle)
									TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  sheriff_SetVehicleMaxMods(vehicle)
                  --sheriff_SetWindowTint(vehicle)

                  SetVehicleModKit(vehicle, 0)
							    SetVehicleLivery(vehicle, 1)

						local rand = math.random(1,9)
                  SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
                  SetVehicleFuelLevel(vehicle, 100.0)
                  exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
						TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
								end)

							else
								ESX.ShowNotification(Ftext_esx_sheriff('service_max') .. inServiceCount .. '/' .. maxInService)
							end

						end, 'sheriff')

					end

				else
					ESX.ShowNotification(Ftext_esx_sheriff('vehicle_out'))
				end

			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'menu_vehicle_spawner1v'
				CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}

			end
		)

	end

end

function sheriff_OpenVehicle1SpawnerMenu(station, partNum)

	local vehicles1 = Config_esx_sheriff.BCSStations[station].Vehicles1

	ESX.UI.Menu.CloseAll()

	if Config_esx_sheriff.EnableSocietyOwnedVehicles1 then

		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles1)

			for i=1, #garageVehicles1, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles1[i].model) .. ' [' .. garageVehicles1[i].plate .. ']', value = garageVehicles1[i]})
			end

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'vehicle_spawner1',
				{
					title    = Ftext_esx_sheriff('vehicle_menu'),
					align = 'right',
					elements = elements,
				},
				function(data, menu)

					menu.close()

					local vehicleProps = data.current.value

					ESX.Game.SpawnVehicle(vehicleProps.model, vehicles1[partNum].SpawnPoint1, 270.0, function(vehicle)

						ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
		
						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'sheriff', vehicleProps)

				end,
				function(data, menu)

					menu.close()

					CurrentAction     = 'menu_vehicle_spawner1'
					CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end
			)

		end, 'sheriff')

	else

		local elements = {}

		for i=1, #Config_esx_sheriff.BCSStations[station].AuthorizedVehicles1, 1 do
			local vehicle = Config_esx_sheriff.BCSStations[station].AuthorizedVehicles1[i]
			table.insert(elements, {label = vehicle.label, value = vehicle.name})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_spawner1',
			{
				title    = Ftext_esx_sheriff('vehicle_menu'),
				align = 'right',
				elements = elements,
			},
			function(data, menu)

				menu.close()

				local model = data.current.value

				local vehicle = GetClosestVehicle(vehicles1[partNum].SpawnPoint1.x,  vehicles1[partNum].SpawnPoint1.y,  vehicles1[partNum].SpawnPoint1.z,  3.0,  0,  71)

				if not DoesEntityExist(vehicle) then

		
					if Config_esx_sheriff.MaxInService == -1 then

						ESX.Game.SpawnVehicle(model, {
							x = vehicles1[partNum].SpawnPoint1.x, 
							y = vehicles1[partNum].SpawnPoint1.y, 
							z = vehicles1[partNum].SpawnPoint1.z
						}, vehicles1[partNum].Heading1, function(vehicle)
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              sheriff_SetVehicleMaxMods(vehicle)
              --sheriff_SetWindowTint(vehicle)

              SetVehicleModKit(vehicle, 0)
							SetVehicleLivery(vehicle, 1)

						local rand = math.random(1,9)
                  SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
                  SetVehicleFuelLevel(vehicle, 100.0)
                  exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
						TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
						end)

					else

						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

							if canTakeService then

								ESX.Game.SpawnVehicle(model, {
									x = vehicles1[partNum].SpawnPoint1.x, 
									y = vehicles1[partNum].SpawnPoint1.y, 
									z = vehicles1[partNum].SpawnPoint1.z
								}, Vehicles1[partNum].Heading, function(vehicle)
									TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  sheriff_SetVehicleMaxMods(vehicle)
                  --sheriff_SetWindowTint(vehicle)

                  SetVehicleModKit(vehicle, 0)
							    SetVehicleLivery(vehicle, 1)

						local rand = math.random(1,9)
                  SetVehicleNumberPlateText(vehicle, "SHERIFF" .. rand)
                  SetVehicleFuelLevel(vehicle, 100.0)
                  exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
						TriggerEvent('esx_vehiclelock:givekey', "SHERIFF" .. rand)
								end)

							else
								ESX.ShowNotification(Ftext_esx_sheriff('service_max') .. inServiceCount .. '/' .. maxInService)
							end

						end, 'sheriff')

					end

				else
					ESX.ShowNotification(Ftext_esx_sheriff('vehicle_out'))
				end

			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'menu_vehicle_spawner1'
				CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}

			end
		)

	end

end

function sheriff_IsInVehicle()
	local ply = playerPed
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function sheriff_OpenbcsActionsMenu()

  ESX.UI.Menu.CloseAll()
  local elements1 = {}

  if (sheriff_IsInVehicle()) then 
    local vehicle = GetVehiclePedIsIn( playerPed, false )
      table.insert(elements1, {label = 'Radar Véhicule', value = 'vehicle_radar'} )
  end

  table.insert(elements1, {label = "[Debug] Supprimes les blips", value = 'debugblip'} )
  table.insert(elements1, {label = "Accessoires", value = 'accessoires'} )
  table.insert(elements1, {label = "Mettre en prison", value = 'jail_menu'} )
  table.insert(elements1, {label = Ftext_esx_sheriff('citizen_interaction'), value = 'citizen_interaction'} )
  table.insert(elements1, {label = Ftext_esx_sheriff('vehicle_interaction'), value = 'vehicle_interaction'} )
  table.insert(elements1, {label = Ftext_esx_sheriff('object_spawner'),      value = 'object_spawner'} )
  table.insert(elements1, {label = "Retirer objets",      value = 'object_remove'} )
  table.insert(elements1, {label = "Unité Canine",      value = 'k9_unit'} )
  table.insert(elements1, {label = "Poser/Récupérer votre radar",      value = 'radar'} )
  table.insert(elements1, {label = "Centrale des bracelets electroniques",      value = 'centralebracelets'} )
  if (PlayerData.job.grade_name == 'boss' or PlayerData.job2.grade_name == 'boss') or (PlayerData.job.grade_name == 'coboss' or PlayerData.job2.grade_name == 'coboss') or (PlayerData.job.grade_name == 'sadj' or PlayerData.job2.grade_name == 'sadj') then
    table.insert(elements1, {label = "Attribuer un matricule",      value = 'attrimatri'} )
  end


  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'sheriff_actions',
    {
      title    = 'Sheriff',
      align = 'right',
	  elements = elements1
    },
	

    function(data, menu)

    if data.current.value == 'debugblip' then
      DeleteBlip()
    end
  
		if data.current.value == 'radar' then
			TriggerEvent('police:deployRadar')
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

		if data.current.value == 'vehicle_radar' then
			  TriggerEvent('esx_vehradar:On')
		end

		if data.current.value == 'accessoires' then
			sheriff_OpenAccessoiresMenu()
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
            title    = Ftext_esx_sheriff('citizen_interaction'),
            align = 'right',
            elements = {
              {label = 'Licences / Permis',                    value = 'license_check'},
              {label = 'Alcool / Drogues',                     value = 'drunk_check'},
              {label = Ftext_esx_sheriff('search'),          value = 'body_search'},
              {label = Ftext_esx_sheriff('handcuff'),        value = 'handcuff'},
              {label = "Escorter",                           value = 'drag'},
              {label = 'Poser un bracelet au suspect',       value = 'braceletgpspose'},
              {label = 'Retirer le bracelet au suspect',     value = 'braceletgpsremove'},
              {label = Ftext_esx_sheriff('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = Ftext_esx_sheriff('out_the_vehicle'), value = 'out_the_vehicle'},
              {label = 	"Amendes", 		                       value = 'fine'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

          if data2.current.value == 'show_fbi' then
            TriggerServerEvent('gc:fbiM')
            TriggerServerEvent('gc:fbi', GetPlayerServerId(player))
          end
          
          if data2.current.value == 'license_check' then
            TriggerEvent('esx_policejob:licencechecker', player)
          end
          
          if data2.current.value == 'freeze' then
            isFreezed = not isFreezed;
            if isFreezed then
              FreezeEntityPosition(GetPlayerServerId(player), true)
            else
              FreezeEntityPosition(GetPlayerServerId(player), false)
            end
          end

          if data2.current.value == 'drunk_check' then
            sheriff_OpenTestDrugDrunkMenu(player)
          end
        
          if data2.current.value == 'identity_card' then
            sheriff_OpenIdentityCardMenu(player)
          end

          if data2.current.value == 'braceletgpspose' then
            TriggerServerEvent('esx_policejob:giveBraceletGps', GetPlayerServerId(player))
          end

          if data2.current.value == 'braceletgpsremove' then
            TriggerServerEvent('esx_policejob:removeBraceletGps', GetPlayerServerId(player))
          end

          if data2.current.value == 'body_search' then
            TriggerServerEvent('core_inventory:custom:searchPlayer', GetPlayerServerId(player))
            -- TriggerServerEvent('core_inventory:server:openInventory', GetPlayerServerId(player), 'otherplayer')
						TriggerServerEvent('esx_policejob:fouiller', GetPlayerServerId(player))
            -- police_OpenBodySearchMenu(player)
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
            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'handcuff', 0.5)
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
            sheriff_OpenFineMenu(player)
          end
        else
          ESX.ShowNotification(Ftext_esx_sheriff('no_players_nearby'))
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
			{label = "Vérifier le véhicule le plus proche", value = 'vehicle_infos'},
			{label = "Mettre le véhicle en fourrière", value = 'del_vehicle'}
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
                    ESX.ShowNotification(Ftext_esx_sheriff('vehicle_impounded'))
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
                    TriggerServerEvent('Core:SetVehicleFourriere', plate)
                    TriggerEvent('Core:ShowNotification', "Le véhicule ~b~"..plate.."~w~ a été mis en fourrière")
                  else
                    ESX.ShowNotification(Ftext_esx_sheriff('must_seat_driver'))
                  end
                else
                  local playerPos =  GetEntityCoords(ped)
                  local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, 3.0, 0.0 )
                  local vehicle = sheriff_GetVehicleInDirection( playerPos, inFrontOfPlayer )
                      
                  if ( DoesEntityExist( vehicle ) ) then
                    ESX.ShowNotification(Ftext_esx_sheriff('vehicle_impounded'))
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
                    ESX.ShowNotification(Ftext_esx_sheriff('must_near'))
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
			'prop_mp_cone_01',
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
            title    = Ftext_esx_sheriff('traffic_interaction'),
            align = 'right',
            elements = {
              {label = Ftext_esx_sheriff('cone'),     value = 'prop_roadcone02a'},
              {label = Ftext_esx_sheriff('barrier'), value = 'prop_barrier_work06a'},
              {label = "Barrière renforcée", value = 'prop_barrier_work06a2'},
              {label = Ftext_esx_sheriff('spikestrips'),    value = 'p_ld_stinger_s'},
              {label = Ftext_esx_sheriff('box'),   value = 'prop_boxpile_07d'},
             --{label = Ftext_esx_sheriff('cash'),   value = 'hei_prop_cash_crate_half_full'}
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

function sheriff_OpenTestDrugDrunkMenu(player)

  if Config_esx_sheriff.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

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
          title    = "Alcool / Drogue",
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

function sheriff_OpenIdentityCardMenu(player)

  if Config_esx_sheriff.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

      --local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      --local idLabel     = nil

      --[[if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end]]--

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Masculin'
        else
          sex = 'Feminin'
        end
        sexLabel = 'Sexe : ' .. sex
      else
        sexLabel = 'Sexe : Inconnue'
      end

      if data.dob ~= nil then
        dobLabel = 'Date de naissance : ' .. data.dob
      else
        dobLabel = 'Date de naissance : Inconnue'
      end

      if data.height ~= nil then
        heightLabel = 'Taille : ' .. data.height
      else
        heightLabel = 'Taille : Inconnue'
      end

      --[[if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Inconnue'
      end]]--

      local elements = {
        {label = Ftext_esx_sheriff('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        --{label = jobLabel,    value = nil}, 
        --{label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = Ftext_esx_sheriff('bac') .. data.drunk / 100 * 4 .. 'g/L de sang', value = nil})
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
          title    = Ftext_esx_sheriff('citizen_interaction'),
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

    ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

      --[[local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = Ftext_esx_sheriff('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = Ftext_esx_sheriff('bac') .. data.drunk / 100 * 4 .. 'g/L de sang', value = nil})
      end]]--

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = Ftext_esx_sheriff('citizen_interaction'),
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

function sheriff_OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

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
      label          = Ftext_esx_sheriff('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = Ftext_esx_sheriff('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = Ftext_esx_sheriff('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = Ftext_esx_sheriff('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = Ftext_esx_sheriff('search'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_sheriff:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          sheriff_OpenBodySearchMenu(player)

        elseif data.current.value == nil and itemType == 'item_amount_choose_money' then

          ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choix_montant',
          {
            title = "[" .. tonumber(amount) .. "$] d'argent sur la personne"
          }, function(data2, menu2)

            local amountSelect = tonumber(data2.value)

            if amountSelect == nil or amountSelect > amount then
              ESX.ShowNotification("Montant invalide")
            else
              TriggerServerEvent('esx_sheriff:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amountSelect)

              sheriff_OpenBodySearchMenu(player)              
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

function sheriff_OpenFineMenu(player)

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
          'dialog', GetCurrentResourceName(), 'sheriff_billing',
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
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sheriff', 'Sheriff', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Sheriff - Amendes", "**" .. GetPlayerName(PlayerId()) .. "** a amendé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
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

function sheriff_OpenFineCategoryMenu(player, category)
  ESX.TriggerServerCallback('esx_sheriff:getFineList', function(fines)

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
        title    = Ftext_esx_sheriff('fine'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config_esx_sheriff.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_sheriff', Ftext_esx_sheriff('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', Ftext_esx_sheriff('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          sheriff_OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )
  end, category)
end

function sheriff_OpenGetWeaponMenu()
  ESX.TriggerServerCallback('esx_sheriff:getArmoryWeapons', function(weapons)

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
        title    = Ftext_esx_sheriff('get_weapon_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_sheriff:removeArmoryWeapon', function()
          sheriff_OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )
  end)
end

function sheriff_OpenPutWeaponMenu()

  local elements   = {}
  
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPONFtext_esx_sheriffNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = Ftext_esx_sheriff('put_weapon_menu'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_sheriff:addArmoryWeapon', function()
        sheriff_OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function sheriff_OpenBuyWeaponsMenu(station)
  local elements = {}
  for i=1, #Config_esx_sheriff.BCSStations[station].AuthorizedWeapons, 1 do
    local weapon = Config_esx_sheriff.BCSStations[station].AuthorizedWeapons[i]
    table.insert(elements, {label = (weapon.label) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_buy_weapons',
    {
      title    = Ftext_esx_sheriff('buy_weapon_menu'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)
      local inventoryName = 'society_sheriff_buy_inventory_big_fdo_weapon_buy_storage';
      ESX.TriggerServerCallback('core_inventory:custom:InventoryCanCarry', function(canCarry)
        if (canCarry) then
          ESX.TriggerServerCallback('esx_sheriff:buy', function(hasEnoughMoney)
            if hasEnoughMoney then
              ESX.TriggerServerCallback('core_inventory:custom:AddItemIntoInventory', function(result)
                sheriff_OpenBuyWeaponsMenu(station)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Sheriff - Armurerie", "**" .. GetPlayerName(PlayerId()) .. "** a acheté **`"..data.current.value.."`** pour `$"..data.current.price.."`", "Yellow")
              end, inventoryName, string.lower(data.current.value), 1, data.current.price)                
            else
              TriggerEvent('Core:ShowNotification', Ftext_esx_sheriff('not_enough_money'))
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

function sheriff_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_sheriff:getStockItems', function(items)

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
        title    = Ftext_esx_sheriff('sheriff_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_sheriff('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_sheriff('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              sheriff_OpenGetStocksMenu()

              TriggerServerEvent('esx_sheriff:getStockItem', itemName, count)
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

function sheriff_OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_sheriff:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_sheriff('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_sheriff('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_sheriff('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              sheriff_OpenPutStocksMenu()
              TriggerServerEvent('esx_sheriff:putStockItems', itemName, count)
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

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Sheriff',
    number     = 'sheriff',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4QsMADM7aapgOgAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAJ5ElEQVRYw72XaWxU1xXH/+++debNmzcznvFuvADGYBuMWQyIzSxJVAiYhgZK0kRFqZKWiJYgNUo+VEhVGilqkzapkg+0atK0qtKWLCZtGlJKShrANrENGGMwXvE69nhmPPtb7u0HJ2koUAUU9Xy8V++cn875v/c/j8edB/ebl5/Lr1+zUhjq7ssEo9E7SkLutPrDDWvupumeJmL0dSXi6bLPzrfX13/1AIvL5/zXiUt2CeY9hcpQYV1ZMlt3Cg8A5fkA4945ceK2APj/dfnYd/bibGsbxkJTAIBVc0u37lid/eiezTkPE2YurlhS5w1nXJEcJVS+e6O6blHxz9cFVGcxFaqHQ5HBGAA8sKMBF7q6bj3HW11sWrwEf2/7BABQW1S0dsMSx9Or63LKnQ5kmYbltrS5iZV3f02SZIEcfv7w1KaFZmAqatmGicmuy6GRk+3Jxrea+w4BwPpFC/Dhuc7bA5iJrwvfWt95cP1S9fGKcq9XEnmVECA4TUylcLlVU13ksCnFRCgRf/f13zo2rMjmwTjYFDQeS081fjA8fKRF3n5trGPg/vrl+OOJ5puPYOOKGvQNjV0/9/wCZUvt2MG71/oPVVb6XZTjHVf643jtTwOImAH6jZ2LxHQiwdmWCYfIpNaLSeP5X5wSLMYhN9vJabrDWVXhc/vFcIPLVdby5snmoS/m37tnD9ouXJgBmCnulH/4+H3zqueXF549d2li57qSJ+pXeH5SWZVLxyct6Y13+vBm4yAcLo0dOHgXiJ3mbSsDamVgmwbKyrzkzJlB62zLCN9+MYIsn4LcHFUsKfJoghFZmpwi7Y88dn9WYU5h4Fzn5WDDzp3Xi/DAt9fW18z3vzOv1PWI25mrlRVKh0oritnoFBX+9mEQ10ZteH0atm6vthfNc/PplMFRywa1TDA7Ax6U5RTlxEaCBsDxYldfGrpPg6xpPC8r2W6ve211Zc6+8lLnQ/dsfOT96UxiHACEzwCM6Yhfs5Az2+MAlttPeXSdCiIjPp+GhnsXgAMDpQz5BR4SCpscBQ+wT0XEMQicSarmKMr+7y2lqXj8c4W5VBEut0soKbXnu4VR9A8lQXlR/6zu5wBpWzn6u7d7d2iy8KNHd2XXUDpN0lEGngOcgghRzQaVA4jFQQAL4OxPNczAGAMHCgLToZIkNN0GOAIGACwDWeYRnEzgtcYrRjBm75X9BacRHr7ZW8C4Zx6u69T1dMXCcgd94ZUrA2CU8+XO8mTlFboIz/OMMZpJxmLTU5MRSinHEwKXN+BQ3b4A4QmXSiSs0b5LQTOdMgHArSv8gw8typ6KWtL4tTgu97IVv2j8V9Oyqiq0dHT8pwMAsCq7YPWy2jpvfzABy54mTz8xvzSa4JHmdMQSHDQnQ2h8nFfFpM5APIrLC4spyM+RMBUzkKYaQAKCvFbNN1JhKDKPojwnegfiEAUdK5b7cbGjbTeAppaOjutHAAALK1zVhGfasoUuHD06iA2r/egLOmFCQnPrJHbdBfuNxiBZscSbTFoqryiyYpgM5idB+DRqT4Qp58+dRThJxNWO4VT5bF3KclH+8pUI8orccJR74feQNV+seR2AKpM8aozLRlxAV08SRQUGMlRDdg4HJxcBZ0p8abEHZXNmqYk0A8dsOBWC81d45OaYPKGTgDGKObNLwJK5jnnFBoaGpnHsxDB23CuDZx6oqrLg1mZkZRSeCEQUZYRjJj7pSIByDgyPJEGsFAbH7KDb64dtM5aanrKtxBjOnB6wS/IAIjhBRA3jI5OmEQ/bJlVYOJzE8ZMhxNMWzEwCmcgwJFl03BKASBo4IgDgIcsC0raMkmINLoUDNW1UV+f7BJ6As5Kck49DgMnmFRN+pLcfIm+BCA6UFWvQlDRUyeaK8lWmOB0Ax0EQRHCEIJOYEedNAeIJY8Q0kWGcgLxsJ1avLEQimoIkcGA2RcbgBStlIRVPYXgwxscTEucPuDA1aSMdjQAQIYqSaJsWbxkUssS4VbUiPJoKRZFgUw7JFBu4pR3nOtSs6gpti1OTnCZRsbDChYStQVUFpiuxUZOKYlZeHg+aiMiITXjzigVJy5UK/NGQYQmGNydfErh0kucJkVQ/U8UwIbCge1QEAk7IPEFHV/L9j6+MHbmpCN+9PPDxlhF/OMrErPIyHadawpA1Ao4DZ8KTHxlLwuFJgXFer+3ivNE0QSQdhxGTsgTFiXQsAzMOFTEBomLi7JAJSeRQlC9AcsgYGU4gOGUcuaEDddWVGA5OAEBah1o1f2HB4pJciRMkB3TdBc2twq0pCHgArwbougO6xwOPW4BXTcGrS9C8AbhdPLyqDbfXC49K4dMofB4JHpeNcNTCufbI4MZ5JfvfaO62ntz/OD5uar7uS6jv3bN956wsbve21a4NhLMJx1EYTIbFnGCMgmdJECsCUAsMBBy1wJgNk+iwoECgcRCWgkXcEKwJcDDBKAMYxXQCON3taTvbbb/+7vHjL9ywkDz71H0PLq/OfrWs2Mu6WjsFxigs0walDFTQIMpOMGbD7xPBrAw4lgEDYEMGGAGYAZIZRyQpwzQMwIzBMm2wGUeAL5DF8udW2ZSIbPO2ww2jqchfrxNhoWwXz9LDW0NDfc5f/jm+r6utTy0tFEvcAQ96+yfQ+F4/Oi4n4HCKyMvXYTMZFBLA8SAwINEptF2I4KXDXTjdEkTCVFBVUwJOVNHVGR479lHo/JzciH+gu89xspN/PhwLjd5gRsXuvHUm5yAj0d4T96/f5CnzTn20uT5QVVCah8GRGI409iBjCnjomwvgdAhgtglCkyB2EpGYiV//vgfJDLB5Uxk2rilEKpZGZ3tf/O33goeOdPT/bK6e1RCHZ3w02nN6aUUFznZ1zQDU1y7Gida2G/a1jTWrZi3Kj75UtyywbW55NnS/jnMdEwiFplFb5QMYBQMF4YDm9hAMW8HKugK4FYrBgRC6OsaufXA69dPG850vXmd6lQtw6mLnl1lKgVxtjndrrbJ3drH8aGmxNnfuHB8m4hlYFoeifA22bWF0PAaTCqgsc6O/N4ye/hj6B2J/ONWReuXk1SsfAUBllo6LoeiX/y84sO+7yLScxVVjKt06UNkkJiePTsUzF7t7oq7hwVTJdDzN5ea5oLlkvPV2N9LTBppbw9fOXQq92t2befJYJ/1V28ClbgDY1bANJ9rO38laDtxVW4Njre0z3ShYTBbpCWVJVbl4vq//vgP7Vhzs7BosPNVq7J6f57pw/nxv+FrMNpuuXjZmRliN4+0X8JXGy889AwD48Q+2fP/0kX2s+59Psnl5BbsA4NkD+287H3+7D/zlg38AACoCQolPmlw11NNrNrWnXxyfjo4cP9OE/2usXVC5PkcuqAWAmqLiO8rxb3TwXzSVi7vJAAAAAElFTkSuQmCC'
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_sheriff:hasEnteredMarker', function(station, part, partNum)
  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = Ftext_esx_sheriff('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = Ftext_esx_sheriff('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'IdentityCheck' then
    CurrentAction     = 'menu_identitycheck'
    CurrentActionMsg  = "Press ~b~E ~s~pour vérifier une identitée"
    CurrentActionData = {}
  end
  
  if part == 'VehicleSpawnPoint1V' then
		CurrentAction     = 'menu_vehicle_spawner1v'
		CurrentActionMsg  = Ftext_esx_sheriff('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = Ftext_esx_sheriff('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_sheriff:hasExitedMarker', function(station, part, partNum)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

AddEventHandler('esx_sheriff:hasEnteredEntityZone', function(entity)

  --local playerPed = GetplayerPed(-1)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'sheriff'  and PlayerData.job.service == 1 and not IsPedInAnyVehicle(playerPed, false)) or 
  (PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff'  and PlayerData.job2.service == 1 and not IsPedInAnyVehicle(playerPed, false)) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = Ftext_esx_sheriff('remove_object')
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

AddEventHandler('esx_sheriff:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

local localication = nil 
function DeleteBlip()
    RemoveBlip(localisation)
end


--[[RegisterNetEvent('esx_sheriff:handcuff')
AddEventHandler('esx_sheriff:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)]]

RegisterNetEvent('esx_sheriff:drag')
AddEventHandler('esx_sheriff:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

RegisterNetEvent('esx_sheriff:putInVehicle')
AddEventHandler('esx_sheriff:putInVehicle', function()

 

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

RegisterNetEvent('esx_sheriff:OutVehicle')
AddEventHandler('esx_sheriff:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(playerPed,  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(playerPed, xnew, ynew, plyPos.z)
end)

-- Create blips
Citizen.CreateThread(function()

  for k,v in pairs(Config_esx_sheriff.BCSStations) do

    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)
    local blip2 = AddBlipForCoord(369.38, -1599.83, 28.95) -- Davis
	

	-- Sandy
    SetBlipSprite (blip, v.Blip.Sprite)
    SetBlipDisplay(blip, v.Blip.Display)
    SetBlipScale  (blip, v.Blip.Scale)
    SetBlipColour (blip, v.Blip.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Ftext_esx_sheriff('map_blip'))
    EndTextCommandSetBlipName(blip)
	
	-- Paleto
	SetBlipSprite (blip2, v.Blip.Sprite)
    SetBlipDisplay(blip2, v.Blip.Display)
    SetBlipScale  (blip2, v.Blip.Scale)
    SetBlipColour (blip2, v.Blip.Colour)
    SetBlipAsShortRange(blip2, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Ftext_esx_sheriff('map_blip'))
    EndTextCommandSetBlipName(blip2)

  end

end)

-- Display markers
function sheriff05()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.service == 1) then
		
      for k,v in pairs(Config_esx_sheriff.BCSStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_esx_sheriff.DrawDistance then
            DrawMarker(Config_esx_sheriff.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z +0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_sheriff.DrawDistance then
            DrawMarker(Config_esx_sheriff.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3,  255, 255, 0, 100, false, true, 2, false, false, false, false)
          end
        end
		
		-- Helicoptere 
		for i=1, #v.HelicoPaleto, 1 do
		  if GetDistanceBetweenCoords(coords,  v.HelicoPaleto[i].Spawner1.x,  v.HelicoPaleto[i].Spawner1.y,  v.HelicoPaleto[i].Spawner1.z,  true) < 3.0 then
			  DrawMarker(39, v.HelicoPaleto[i].Spawner1.x, v.HelicoPaleto[i].Spawner1.y, v.HelicoPaleto[i].Spawner1.z+0.90, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		  end
		end

        if (Config_esx_sheriff.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		        (Config_esx_sheriff.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_sheriff.DrawDistance then
              DrawMarker(Config_esx_sheriff.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3,  255, 255, 0, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end
end

-- Enter / Exit marker events
function sheriff04()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.service == 1) then

   
      
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config_esx_sheriff.BCSStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_esx_sheriff.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_sheriff.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
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
		
		for i=1, #v.HelicoPaleto, 1 do

		  if GetDistanceBetweenCoords(coords,  v.HelicoPaleto[i].Spawner1.x,  v.HelicoPaleto[i].Spawner1.y,  v.HelicoPaleto[i].Spawner1.z,  true) < 3.0 then
			isInMarker     = true
			currentStation = k
			currentPart    = 'VehicleSpawner1V'
			currentPartNum = i
		  end

		  if GetDistanceBetweenCoords(coords,  v.HelicoPaleto[i].SpawnPoint1.x,  v.HelicoPaleto[i].SpawnPoint1.y,  v.HelicoPaleto[i].SpawnPoint1.z,  true) < 3.0 then
			isInMarker     = true
			currentStation = k
			currentPart    = 'VehicleSpawnPoint1V'
			currentPartNum = i
		  end

		end


        if (Config_esx_sheriff.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_sheriff.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_sheriff.MarkerSize.x then
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
          TriggerEvent('esx_sheriff:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_sheriff:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_sheriff:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end
end

-- Enter / Exit entity zone events
function sheriff03()
  
    

    local closestDistance = -1
    local closestEntity   = nil

    --[[for i=1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end

      end

    end]]

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_sheriff:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_sheriff:hasExitedEntityZone', LastEntity)
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

function sheriff02()
	if (PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.service == 1) then
		
      for k,v in pairs(Config_esx_sheriff.BCSStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z  + 1, 'Appuyez sur ~y~E~s~ pour vous changer')
		      end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z  + 1, 'Appuyez sur ~y~E~s~ pour accéder à l\'armurerie')
		      end
        end

        for i=1, #v.IdentityCheck, 1 do
          if GetDistanceBetweenCoords(coords,  v.IdentityCheck[i].x,  v.IdentityCheck[i].y,  v.IdentityCheck[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.IdentityCheck[i].x,  v.IdentityCheck[i].y,  v.IdentityCheck[i].z  + 1, 'Appuyez sur ~b~E~s~ pour vérifier une identitée')
		      end
        end
		
		for i=1, #v.HelicoPaleto, 1 do
		  if GetDistanceBetweenCoords(coords,  v.HelicoPaleto[i].Spawner1.x,  v.HelicoPaleto[i].Spawner1.y,  v.HelicoPaleto[i].Spawner1.z,  true) < 3.0 then
        sleepThread = 20
        DrawText3Ds(v.HelicoPaleto[i].Spawner1.x,  v.HelicoPaleto[i].Spawner1.y,  v.HelicoPaleto[i].Spawner1.z + 0.90, 'Appuyez sur ~y~E~s~ pour sortir ou ranger l\'helicoptère') 
		  end
		end

        if (Config_esx_sheriff.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		       (Config_esx_sheriff.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

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


RegisterNetEvent("nebularp_gyrophare_sheriff:delveh")
AddEventHandler("nebularp_gyrophare_sheriff:delveh", function(realNetid)
	netid = realNetid
end)


-- Key Controls
function sheriff01()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
      if (IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.service == 1 and (GetGameTimer() - GUI.Time) > 150) or
	  (IsControlPressed(0,  Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'sheriff' and PlayerData.job2.service == 1 and (GetGameTimer() - GUI.Time) > 150) then

        if CurrentAction == 'menu_cloakroom' then
          sheriff_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          sheriff_OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_identitycheck' then
          police_OpenCheckIdentity()
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          sheriff_OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end
		
		if CurrentAction == 'menu_vehicle_spawnerv' then
          sheriff_OpenVehicleVSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end
		
		if CurrentAction == 'menu_vehicle_spawner1' then
		  sheriff_OpenVehicle1SpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		end
		
    if CurrentAction == 'menu_vehicle_spawner1v' then
      if sheriff_IsInVehicle() then
        SetEntityAsMissionEntity(GetVehiclePedIsUsing(playerPed), true, true)
        ESX.Game.DeleteVehicle(GetVehiclePedIsUsing(playerPed))
      else
        sheriff_OpenVehicle1VSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
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

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'sheriff', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Ftext_esx_sheriff('open_bossmenu')
            CurrentActionData = {}

          end)

        end 

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end 
end

function sheriff_GetVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, playerPed, 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

RegisterNetEvent('esx_sheriff:openMenuJob')
AddEventHandler('esx_sheriff:openMenuJob', function()
	sheriff_OpenbcsActionsMenu()
end)


Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing


function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Drawing.drawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

------------------------------------------
------------------------------------------
------Modifier text-----------------------
------------------------------------------
------------------------------------------

function msginf(msg, duree)
    duree = duree or 500
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end
