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

function _U(txt)
	return Config_MusicRecord.Txt[txt]
end

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local isInMarker              = false

local function DrawText3Ds(x, y, z, text)
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

-- Create blips
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(Config_MusicRecord.Zones.BossActions.Pos.x, Config_MusicRecord.Zones.BossActions.Pos.y, Config_MusicRecord.Zones.BossActions.Pos.z)
  SetBlipSprite (blip, 136)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 27)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("VANGUARD Record")
  EndTextCommandSetBlipName(blip)
end)

local function record_IsGradeBoss()
  if (PlayerData.job.name == "musicrecord" and (PlayerData.job.grade_name == "boss" or PlayerData.job.grade_name == "coboss")) or (PlayerData.job2.name == "musicrecord" and (PlayerData.job2.grade_name == "boss" or PlayerData.job2.grade_name == "coboss")) then
    return true
  else
    return false
  end
end

function record_OpenCloakroomMenu()
  local elements = {
    {label = "Dressing", value = 'garde_robe'},
  }
	
	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
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
					  title    = 'Changer de tenue',
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
							TriggerEvent('Core:ShowNotification', 'Vous avez bien récupéré la tenue')
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
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function record_OpenMobileReporterActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_reporter_actions',
    {
      title    = 'VANGUARD Record',
	  align = 'right',
      elements = {
        {label = 'Facture', value = 'billing'},
        {label = 'Micro', value = 'mic'},
        {label = 'Micro Perche', value = 'bmic'}
      }
    },
    function(data, menu)
      if data.current.value == 'mic' then
        TriggerEvent("Mic:ToggleMic")
      end
      
      if data.current.value == 'bmic' then
        TriggerEvent("Mic:ToggleBMic")
      end
	
      if data.current.value == 'billing' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'billing',
          {
            title = "Montant"
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              TriggerEvent('Core:ShowNotification', "Montant invalide")
            else

              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                TriggerEvent('Core:ShowNotification', "Aucun joueur à proximité")
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_musicrecord', 'Music Label VANGUARD', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Music Record - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
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

function record_OpenVaultMenu()

  if Config_MusicRecord.EnableVaultManagement then

    local elements = {
      {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
			{label = 'Ouvrir le stockage', value = 'get_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = _U('vault'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_musicrecord')
          menu.close()
        end
        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_musicrecord')
          menu.close()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    )

  end

end

function record_OpenGetStocksMenu()
  ESX.TriggerServerCallback('esx_musicrecord:getStockItems', function(items)
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
        table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Label stock',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              TriggerEvent('Core:ShowNotification', _U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              record_OpenGetStocksMenu()

              TriggerServerEvent('esx_musicrecord:getStockItem', itemName, count)
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

function record_OpenPutStocksMenu()
  ESX.TriggerServerCallback('esx_musicrecord:getPlayerInventory', function(inventory)

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
        title    = _U('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              TriggerEvent('Core:ShowNotification', _U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              record_OpenPutStocksMenu()

              TriggerServerEvent('esx_musicrecord:putStockItems', itemName, count)
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

function record_OpenGetWeaponMenu(station)

  ESX.TriggerServerCallback('esx_groupes:getArmoryWeapons', function(weapons)

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
        title    = "Prendre une arme",
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_groupes:removeArmoryWeapon', function()
          record_OpenVaultMenu()
        end, data.current.value, "musicrecord", ESX.GetWeaponLabel(data.current.value))

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, "musicrecord")
end

function record_OpenPutWeaponMenu()

  local elements   = {}
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = "Déposer une arme",
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()
      ESX.TriggerServerCallback('esx_groupes:addArmoryWeapon', function(isAdded)
        record_OpenVaultMenu()
        while isAdded == nil do
          Citizen.Wait(10)
        end
        if isAdded then
          local weaponList = ESX.GetWeaponList()
          local playerPed = PlayerPedId()
        
          for i=1, #weaponList, 1 do
        
            if weaponList[i].name == data.current.value then
        
              local weaponHash = GetHashKey(weaponList[i].name)
        
              while HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' do
                local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                local weaponHash = GetHashKey(data.current.value)
        
                RemoveWeaponFromPed(playerPed, weaponHash)
                TriggerEvent('esx:removeInventoryItem', {label = ESX.GetWeaponLabel(data.current.value)}, 1)
              
                if ammo then
                  local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
                  local finalAmmo = math.floor(pedAmmo - ammo)
                  SetPedAmmo(playerPed, weaponHash, finalAmmo)
                else
                  SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
                end
                Citizen.Wait(0)
              end
            end
        
          end
        end
      end, data.current.value, "musicrecord", ESX.GetWeaponLabel(data.current.value))

    end,
    function(data, menu)
      menu.close()
    end
  )
end

AddEventHandler('esx_musicrecord:hasEnteredMarker', function(zone)
    if zone == 'BossActions' and record_IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end

    if zone == 'craft' then
      CurrentAction     = 'menu_craft'
      CurrentActionMsg  = "Appuie sur ~y~E~w~ pour produire un tube !"
      CurrentActionData = {}
    end	
	
    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
	
    if Config_MusicRecord.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    end	
end)

local function record_OpenCraftMenu()
  local elements = {
    {label = "Produire un single [200$]", value = 'single', price = 200},
    {label = "Produire un album [400$]", value = 'album', price = 400}
  }
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'craft_musiclabel',
    {
      title    = "Graver le(s) CD(s)",
      align = 'right',
      elements = elements,
    },
    function(data, menu)
      if data.current.value == 'single' or data.current.value == 'album' then        
        TriggerServerEvent('esx_musicrecord:canCraftObject', data.current.value, data.current.price)
      end
    end,
    function(data, menu)
      menu.close()

      CurrentAction     = 'menu_craft'
      CurrentActionMsg  = "Appuie sur E pour produire un tube !"
      CurrentActionData = {}
    end)  
end

RegisterNetEvent("esx_musicrecord:craftObject")
AddEventHandler("esx_musicrecord:craftObject", function(itemName)
  -- Play Animation
  RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
  while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
      Citizen.Wait(1)
  end
  TriggerEvent('xPiwel_skin:NoStopAnim', true)

  FreezeEntityPosition(PlayerPedId(), true)
  SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true) -- Désarmé le joueur

  TriggerEvent('progressBar:drawBar', true, 10000, "GRAVURE EN COURS")
  TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
  Citizen.Wait(10000)

  ClearPedTasks(PlayerPedId())
  FreezeEntityPosition(PlayerPedId(), false)

  TriggerEvent('xPiwel_skin:NoStopAnim', false)
  TriggerServerEvent('esx_musicrecord:AddItem', itemName)

  ESX.UI.Menu.CloseAll()

  CurrentAction     = 'menu_craft'
  CurrentActionMsg  = "Appuie sur E pour produire un tube !"
  CurrentActionData = {}
end)


AddEventHandler('esx_musicrecord:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

-- Display markers
function record02()
    for k,v in pairs(Config_MusicRecord.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_MusicRecord.DrawDistance) then
            DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, false, 2, false, false, false, false)
        end
    end
    for k,v in pairs(Config_MusicRecord.CraftZones) do
      if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config_MusicRecord.DrawDistance then
          DrawMarker(0, v.x, v.y, v.z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, false, 2, false, false, false, false)
      end
    end
end

-- Enter / Exit marker events
function record01()
  local coords      = coords
  local isInMarker  = false
  local currentZone = nil

  for k,v in pairs(Config_MusicRecord.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k
      end
  end

  for k,v in pairs(Config_MusicRecord.CraftZones) do
    if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.3) then
        isInMarker  = true
        currentZone = "craft"
    end
  end

  if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_musicrecord:hasEnteredMarker', currentZone)
  end

  if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_musicrecord:hasExitedMarker', LastZone)
  end
end

function record04()

	if (PlayerData.job ~= nil and PlayerData.job.name == 'musicrecord' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'musicrecord' and PlayerData.job2.service == 1) then
	
		if GetDistanceBetweenCoords(coords, Config_MusicRecord.Zones.Cloakrooms.Pos.x, Config_MusicRecord.Zones.Cloakrooms.Pos.y, Config_MusicRecord.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_MusicRecord.Zones.Cloakrooms.Pos.x, Config_MusicRecord.Zones.Cloakrooms.Pos.y, Config_MusicRecord.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour se changer')
		end

		if GetDistanceBetweenCoords(coords, Config_MusicRecord.Zones.Vaults.Pos.x, Config_MusicRecord.Zones.Vaults.Pos.y, Config_MusicRecord.Zones.Vaults.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_MusicRecord.Zones.Vaults.Pos.x, Config_MusicRecord.Zones.Vaults.Pos.y, Config_MusicRecord.Zones.Vaults.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au coffre')
		end

    for k, v in pairs(Config_MusicRecord.CraftZones) do
      if GetDistanceBetweenCoords(coords, v.x, v.y, v.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(v.x, v.y, v.z + 1, 'Appuyez sur ~y~E~s~ pour produire un tube !')
      end
    end
		
		if Config_MusicRecord.EnablePlayerManagement and (PlayerData.job ~= nil and PlayerData.job.name == 'musicrecord' and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'coboss') and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'musicrecord' and (PlayerData.job2.grade_name == 'boss' or PlayerData.job2.grade_name == 'coboss') and PlayerData.job2.service == 1) then		
			if GetDistanceBetweenCoords(coords, Config_MusicRecord.Zones.BossActions.Pos.x, Config_MusicRecord.Zones.BossActions.Pos.y, Config_MusicRecord.Zones.BossActions.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_MusicRecord.Zones.BossActions.Pos.x, Config_MusicRecord.Zones.BossActions.Pos.y, Config_MusicRecord.Zones.BossActions.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ouvrir le boss menu')
			end
		end
			
	end
end

-- Key Controls
function record03()
    if CurrentAction ~= nil then
      if IsControlJustReleased(0, Keys['BACKSPACE']) then
        ESX.UI.Menu.CloseAll()
        CurrentAction = nil
	    end
	  
      if IsControlJustReleased(0,  Keys['E']) then

        if CurrentAction == 'menu_cloakroom' then
          record_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_craft' then
          record_OpenCraftMenu()
        end

        if CurrentAction == 'menu_vault' then
          record_OpenVaultMenu()
        end
		
        if CurrentAction == 'menu_boss_actions' and record_IsGradeBoss() then

          local options = {
            wash      = Config_MusicRecord.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'musicrecord', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

        
        CurrentAction = nil

      end

    end
end

RegisterNetEvent('esx_musicrecord:openMenuJob')
AddEventHandler('esx_musicrecord:openMenuJob', function()
	record_OpenMobileReporterActionsMenu()
end)


xSound = exports.xsound
RegisterNetEvent("esx_musicrecord:playmusic")
AddEventHandler("esx_musicrecord:playmusic", function(data)
    local pos = vec3(-987.46, -71.42, -99.00)
    if xSound:soundExists("musicrecord") then
      xSound:Destroy("musicrecord")
    end
    xSound:PlayUrlPos("musicrecord", data, 0.1, pos)
    xSound:Distance("musicrecord", 25)
    xSound:Position("musicrecord", pos)
end)

RegisterNetEvent("esx_musicrecord:pausemusicrecord")
AddEventHandler("esx_musicrecord:pausemusicrecord", function(status)
	if status == "play" then
    xSound:Resume("musicrecord")
	elseif status == "pause" then
    xSound:Pause("musicrecord")
	end
end)

RegisterNetEvent("esx_musicrecord:volumemusicrecord")
AddEventHandler("esx_musicrecord:volumemusicrecord", function(volume)
  xSound:setVolume("musicrecord", volume / 20)
end)

RegisterNetEvent("esx_musicrecord:stopmusicrecord")
AddEventHandler("esx_musicrecord:stopmusicrecord", function()
  xSound:Destroy("musicrecord")
end)

RegisterNetEvent("esx_musicrecord:playmusic2")
AddEventHandler("esx_musicrecord:playmusic2", function(data)
    local pos = vec3(259.87, -36.077, 76.50)
    if xSound:soundExists("musicrecord2") then
      xSound:Destroy("musicrecord2")
    end
    xSound:PlayUrlPos("musicrecord2", data, 0.1, pos2)
    xSound:Distance("musicrecord2", 20)
    xSound:Position("musicrecord2", pos2)
end)

RegisterNetEvent("esx_musicrecord:pausemusicrecord2")
AddEventHandler("esx_musicrecord:pausemusicrecord2", function(status)
	if status == "play" then
    xSound:Resume("musicrecord2")
	elseif status == "pause" then
    xSound:Pause("musicrecord2")
	end
end)

RegisterNetEvent("esx_musicrecord:volumemusicrecord2")
AddEventHandler("esx_musicrecord:volumemusicrecord2", function(volume)
  xSound:setVolume("musicrecord2", volume / 100)
end)

RegisterNetEvent("esx_musicrecord:stopmusicrecord2")
AddEventHandler("esx_musicrecord:stopmusicrecord2", function()
  xSound:Destroy("musicrecord2")
end)