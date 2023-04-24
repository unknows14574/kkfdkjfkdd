RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  
  if (PlayerData.job ~= nil and PlayerData.job.name == 'pizzathis' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'pizzathis' and PlayerData.job2.service == 1) then
	TriggerServerEvent("player:serviceOn", "pizzathis")
  end
end)

local nbpizzathis = 0
--CONFIGURATION--
local pizzathis = { x = 813.62, y = -735.72, z = 27.60 - 0.98} --Configuration marker début de service
local pizzathisfin = { x = 810.19, y = 810.1994, z = 27.60 - 0.98} --Configuration marker fin de service
local cuisine_water = { x = 813.51, y = -749.43, z = 26.78 } --Préparation boisson
local cuisine_food = { x = 812.14, y = -754.87, z = 26.78 } -- Préparation bouffe
local frigo = { x = 806.36, y = -761.63, z = 26.78 }
local vestiaire = { x = 812.70, y = -762.04, z = 31.26 }
local boss = { x = 797.04, y = -750.68, z = 31.26 }

local pointtrunk = { x = 414.64, y = -1929.20, z = 24.44 }

local livpt = { --Configuration des points de livraisons (repris ceux de Maykellll1 / NetOut)
  [1] = {name = "Tattoo Vinewood",x = 320.73, y = 177.26 , z = 103.58},
  [2] = {name = "Auto Luxury",x = -803.28, y = -224.08 , z = 37.22},
  [3] = {name = "Prefecture",x = -595.04, y = -337.92 , z = 34.85 },
  [4] = {name = "Pole Emploi",x = -261.25, y = -971.60 , z = 31.21 },
  [5] = {name = "Bennys",x = -232.50, y = -1311.25 , z = 31.29 },
  [6] = {name = "Unicorn" ,x = 129.17, y = -1299.19 , z = 29.23 },
  [7] = {name = "Motosport" ,x = -38.46, y = -1109.55, z = 26.43 },
  [8] = {name = "Auto Ecole" ,x = 218.51, y = -1390.82, z = 30.58 },
  [9] = {name = "Police" ,x = 433.28, y = -981.88, z = 30.70},
  [10] ={name = "Animalerie",x = -663.88, y = -945.60, z = 21.63},
  [11] ={name = "Coiffeur",x = -1288.56, y = -1116.48, z = 6.98},
  [12] ={name ="Coiffeur Street",x = 132.47, y =-1712.29 , z = 29.29},
  [13] ={name ="Taxi", x = 908.23, y = -160.81 ,z = 74.13},
  [14] ={name ="Ballas", x = -115.97, y = -1772.27,z = 29.85 - 0.98},
  [15] ={name ="Vagos" , x = 363.94, y = -1987.77, z = 24.23 - 0.98},
  [16] ={name ="Familys" , x = 65.83, y = -1467.50, z = 29.29 - 0.98 },
  [17] ={name ="Hopital" ,x= 298.09, y=-584.16,z = 43.26},
  [18] ={name ="Palais de justice" ,x= 235.49, y=-411.45,z = 48.11},
  [19] ={name ="Banque" ,x= 229.82, y=214.12,z = 105.54},
  [20] ={name ="Banque" ,x= 151.21, y=-1036.51,z = 29.33},
  [21] ={name ="Armurerie" ,x= 17.03, y=-1116.35,z = 29.79},
  [22] ={name ="Tattoo Mara" ,x= 1321.02, y=-1649.30,z = 52.14},
  [23] ={name ="Superette Vespucci" ,x= -1226.96, y=-902.06,z = 12.66}, --Shop 3
  [24] ={name ="Superette" ,x= -711.76, y=-917.52,z = 19.21}, --Shop 5
  [25] ={name ="Superette Unicorn" ,x= 29.16, y=-1349.92,z = 29.33}, --Shop 1
  [26] ={name ="Superette" ,x= 1142.49, y=-980.68,z = 46.20}, --Shop 6
  [27] ={name ="Superette Mirror Park" ,x= 1159.91, y=-327.64,z = 69.20}, --Shop 8
  [28] ={name ="Superette Vinewood" ,x= 376.35, y=322.39,z = 103.43}, --Shop 7
  [29] ={name ="Superette Ballas" ,x= -53.62, y=-1757.36,z = 29.43}, --Shop 2
  [30] ={name ="Superette Brokers" ,x= -1491.60, y=-384.21,z = 40.05}, --Shop 4
  [31] ={name ="Binco" ,x= 417.34, y=-807.59,z = 29.39},
  [32] ={name ="Ponsonbys" ,x= -153.82, y=-306.29,z = 38.68},
  [33] ={name ="Bijouterie" ,x= -632.01, y=-238.05,z = 38.07},
  [34] ={name ="Armurerie" ,x= 811.73, y=-2147.13,z = 29.46},
  [35] ={name ="Tabac" ,x= 72.49, y=178.51,z = 104.59},
  [36] ={name ="Avocat" ,x= -113.77, y=-596.52,z = 36.28},
  [37] ={name ="Fouriere" ,x= 486.84, y=-1295.96,z = 29.55},
  [38] ={name ="Hopital" ,x= 307.27, y=-1433.81,z = 29.90},
  [39] ={name ="Lifeinvader" ,x= -1081.86, y=-260.34,z = 37.80},
  [40] ={name ="Police" ,x= 826.71, y=-1290.12,z = 28.24},
  [41] ={name ="Tequilala" ,x= -564.60, y=274.36,z = 83.01},
  [42] ={name ="Bahamas" ,x= -1388.60, y=-586.52,z = 30.21},
  [43] ={name ="Hopital" ,x= -491.91, y=-335.64,z = 34.50},
  [44] ={name ="Avocat" ,x= -1894.37, y=-566.83,z = 11.80},
  [45] ={name ="Station Essence" ,x= 645.43, y=267.80,z = 103.22},
  [46] ={name ="Coiffeur" ,x= 1206.35, y=-470.37,z = 66.19},
  [47] ={name ="Outilllage" ,x= 548.63, y=-172.68,z = 54.48},
  [48] ={name ="Bean Machine" ,x= -627.99, y=238.98,z = 81.89}
}

local blips = {
  {title="Pizza this", colour=25, id=267, x = 798.28, y = -750.40, z = 26.78 - 0.98}, --Configuration du point sur la carte
}

local coefflouze = 0.1 --Coeficient multiplicateur qui en fonction de la distance definit la paie

--INIT--

local isInJobPizz = false
local livr = 0
local isToHouse = false
local isTopizzathisria = false

local pourboire = 300
local px = 0
local py = 0
local pz = 0

local CanAskForNewJob = true
local WaitingForLimitationReach = false
local hasCheckLimitation = false

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

--THREADS--

Citizen.CreateThread(function() --Thread d'ajout du point de la pizzathis sur la carte

  for _, info in pairs(blips) do

    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.6)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
  end

end)

function pizzathis04() --Thread lancement + livraison depuis le marker vert
  if PlayerData.job ~= nil then
    if PlayerData.job.name ~= nil then
      if PlayerData.job.name == "pizzathis" and PlayerData.job.service == 1 then
        if isInJobPizz == false then
          if GetDistanceBetweenCoords(pizzathis.x, pizzathis.y, pizzathis.z, GetEntityCoords(playerPed,true)) < 15.0 then
            DrawMarker(0,pizzathis.x,pizzathis.y,pizzathis.z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,0,255,0, 200, 0, 0, 0, 0)
          end

          if GetDistanceBetweenCoords(pizzathis.x, pizzathis.y, pizzathis.z, GetEntityCoords(playerPed,true)) < 1.5 then
            sleepThread = 20
            if not hasCheckLimitation then
              TriggerServerEvent('esx_pizzathisjob:checkForLimitation')
            end
            WaitingForLimitationReach = true
            while WaitingForLimitationReach and not hasCheckLimitation do
              Wait(500)
            end
            if CanAskForNewJob == false then
              DrawText3Ds(pizzathis.x, pizzathis.y, pizzathis.z-0.3, "Vous avez atteint votre quota de livraison. Revenez demain")
              do return end
            end

            DrawText3Ds(pizzathis.x, pizzathis.y, pizzathis.z-0.3, "Appuyez sur ~g~E~s~ pour lancer les livraisons")

            if IsControlJustPressed(1,38) then
              if IsVehicleModel(GetVehiclePedIsIn(playerPed, true), GetHashKey("issi3")) or IsVehicleModel(GetVehiclePedIsIn(playerPed, true), GetHashKey("faggio"))  then
                hasCheckLimitation = false

                notif = true
                isInJobPizz = true
                isToHouse = true
                livr = math.random(1, 48)

                px = livpt[livr].x
                py = livpt[livr].y
                pz = livpt[livr].z
                distance = pizzathis_round(GetDistanceBetweenCoords(pizzathis.x, pizzathis.y, pizzathis.z, px,py,pz))
                paie = distance * coefflouze

                pizzathis_goliv(livpt,livr)
                nbpizzathis = math.random(1, 3)

                TriggerServerEvent("pizzathis:itemadd", nbpizzathis)
              else
                TriggerEvent('Core:ShowNotification','Tu dois être en faggio ou en issi classic pour effectuer les livraisons')
              end
            end
          end
        end
        if isToHouse == true then
          destinol = livpt[livr].name
          while notif == true do
            TriggerEvent('Core:ShowNotification', "Direction : ~y~" .. destinol .. "~w~ pour livrer la commande")
            notif = false
            i = 1
          end

          DrawMarker(0,livpt[livr].x,livpt[livr].y,livpt[livr].z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,0,255,0, 200, 0, 0, 0, 0)

          if GetDistanceBetweenCoords(px,py,pz, GetEntityCoords(playerPed,true)) < 3 then
            sleepThread = 20
            DrawText3Ds(px,py,pz-0.3, "Appuyez sur ~g~E~s~ pour livrer la ~r~commande")

            if IsControlJustPressed(1,38) then
              notif2 = true
              afaitunepizzathismin = true

              TriggerServerEvent("pizzathis:itemrm")
              nbpizzathis = nbpizzathis - 1

              TriggerServerEvent("pizzathis:pourboire", pourboire)

              RemoveBlip(liv)
              Wait(250)
              if nbpizzathis == 0 then
                isToHouse = false
                isTopizzathisria = true
              else
                isToHouse = true
                isTopizzathisria = false
                livr = math.random(1, 48)

                px = livpt[livr].x
                py = livpt[livr].y
                pz = livpt[livr].z

                distance = pizzathis_round(GetDistanceBetweenCoords(pizzathis.x, pizzathis.y, pizzathis.z, px,py,pz))

                destinol = livpt[livr].name
                TriggerEvent('Core:ShowNotification', "Direction : ~y~" .. destinol .. "~w~ pour livrer la commande")

                paie = distance * coefflouze

                pizzathis_goliv(livpt,livr)
              end
            end
          end
        end
        if isTopizzathisria == true then

          while notif2 == true do
            SetNewWaypoint(pizzathis.x,pizzathis.y)
            TriggerEvent('Core:ShowNotification',"Direction la pizzeria, tu as livré toutes tes commandes")
            hasCheckLimitation = false
            notif2 = false
          end
          if GetDistanceBetweenCoords(pizzathis.x, pizzathis.y, pizzathis.z, GetEntityCoords(playerPed,true)) < 15.0 then
            DrawMarker(0,pizzathis.x,pizzathis.y,pizzathis.z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,0,255,0, 200, 0, 0, 0, 0)
          end
          if GetDistanceBetweenCoords(pizzathis.x,pizzathis.y,pizzathis.z, GetEntityCoords(playerPed,true)) < 3 and afaitunepizzathismin == true then
            if not hasCheckLimitation then
              TriggerServerEvent('esx_pizzathisjob:checkForLimitation')
            end

            WaitingForLimitationReach = true
            while WaitingForLimitationReach and not hasCheckLimitation do
              Wait(500)
            end
            if CanAskForNewJob then
              sleepThread = 20
              DrawText3Ds(pizzathis.x,pizzathis.y,pizzathis.z-0.3, "Appuyez sur ~g~E~s~ pour récuperer la ~r~commande")
            end 
            if IsControlJustPressed(1,38) then

              if pizzathis_IsInVehicle() then
                if IsVehicleModel(GetVehiclePedIsIn(playerPed, true), GetHashKey("issi3")) or IsVehicleModel(GetVehiclePedIsIn(playerPed, true), GetHashKey("faggio"))  then
                  afaitunepizzathismin = false

                  isInJobPizz = true
                  isToHouse = true
                  livr = math.random(1, 48)

                  px = livpt[livr].x
                  py = livpt[livr].y
                  pz = livpt[livr].z

                  distance = pizzathis_round(GetDistanceBetweenCoords(pizzathis.x, pizzathis.y, pizzathis.z, px,py,pz))
                  paie = distance * coefflouze
                  
                  destinol = livpt[livr].name
                  TriggerEvent('Core:ShowNotification', "Direction : ~y~" .. destinol .. "~w~ pour livrer la commande")

                  pizzathis_goliv(livpt,livr)
                  nbpizzathis = math.random(1, 3)
                  TriggerServerEvent("pizzathis:itemadd", nbpizzathis)
                else
                  TriggerEvent('Core:ShowNotification','Tu dois être en faggio ou en issi classic pour effectuer les livraisons')
                end
              end
            end
          end
        end
        if IsEntityDead(playerPed) then

        isInJobPizz = false
        livr = 0
        isToHouse = false
        isTopizzathisria = false

        paie = 0
        px = 0
        py = 0
        pz = 0
        RemoveBlip(liv)

        end
      end
    end
  end
end

function pizzathis03() -- Thread de "fin de service" depuis le point rouge
    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "pizzathis" and PlayerData.job.service == 1 then
          if isInJobPizz == true then

            if GetDistanceBetweenCoords(pizzathisfin.x, pizzathisfin.y, pizzathisfin.z, GetEntityCoords(playerPed,true)) < 15.0 then
              DrawMarker(0,pizzathisfin.x,pizzathisfin.y,pizzathisfin.z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,255,0,0, 200, 0, 0, 0, 0)
            end

            if GetDistanceBetweenCoords(pizzathisfin.x, pizzathisfin.y, pizzathisfin.z, GetEntityCoords(playerPed,true)) < 1.5 then
              sleepThread = 20
              DrawText3Ds(pizzathisfin.x, pizzathisfin.y, pizzathisfin.z-0.3, "Appuyez sur ~g~E~s~ pour arrêter la livraison de ~r~pizzathis")

              if IsControlJustPressed(1,38) then
                TriggerServerEvent('pizzathis:deleteAllPizz')
                isInJobPizz = false
                livr = 0
                isToHouse = false
                isTopizzathisria = false

                paie = 0
                px = 0
                py = 0
                pz = 0

                if afaitunepizzathismin == true then

                  local vehicleu = GetVehiclePedIsIn(playerPed, false)

                  SetEntityAsMissionEntity( vehicleu, true, true )
                -- pizzathis_deleteCar( vehicleu )

                TriggerEvent('Core:ShowNotification',"Merci d'avoir travaillé, bonne journée")

                  --TriggerServerEvent("pizzathis:paiefinale")

                  SetWaypointOff()

                  afaitunepizzathismin = false

                else

                  local vehicleu = GetVehiclePedIsIn(playerPed, false)

                  SetEntityAsMissionEntity( vehicleu, true, true )
                  --pizzathis_deleteCar( vehicleu )

                  TriggerEvent('Core:ShowNotification',"Merci quand même (pour rien), bonne journée")

                end
              end
            end
          end
        end
      end
    end
end

--FONCTIONS--

function pizzathis_goliv(livpt,livr) -- Fonction d'ajout du point en fonction de la destination de livraison chosie
  liv = AddBlipForCoord(livpt[livr].x,livpt[livr].y, livpt[livr].z)
  SetBlipSprite(liv, 1)
  SetNewWaypoint(livpt[livr].x,livpt[livr].y)
end

function pizzathis_round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function pizzathis_deleteCar( entity )
  Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) ) --Native qui del le vehicule
end

function pizzathis_IsInVehicle() --Fonction de verification de la presence ou non en vehicule du joueur
  local ply = playerPed
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

function pizzathis_OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_pizzathisjob:getStockItems', function(items)

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

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pizzathis_stocks_menu', {
				title    = 'Pizza Stock',
				align = 'right',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
						title = 'quantité'
					}, function(data2, menu2)
		
						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							TriggerEvent('Core:ShowNotification', 'quantité invalide')
						else
							menu2.close()
							menu.close()
							pizzathis_OpenGetStocksMenu()

							TriggerServerEvent('esx_pizzathisjob:getStockItem', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function pizzathis_OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_pizzathisjob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end
			
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pizzathis_stocks_menu', {
			title    = 'Inv',
			align = 'right',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
					title = 'quantité'
				}, function(data2, menu2)

					local count = tonumber(data2.value)

					if count == nil or count <= 0 then
						TriggerEvent('Core:ShowNotification','quantité invalide')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_pizzathisjob:putStockItems', itemName, count)
					end
				end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)

			menu.close()
		end)
		
		
	end)
end

function pizzathis_OpenpizzathisStockMenu()

	local elements = {
    {label = 'Ouvrir le stockage', value = 'get_stock'}
  }
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pizzathis_actions', {
			title    = 'Frigo',
			align = 'right',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'get_stock' then
        TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_pizzathis')
        menu.close()
      end

		end, function(data, menu)

			menu.close()
		end)
end

function pizzathis_SpawnVehicle(vehicle)

	ESX.Game.SpawnVehicle(vehicle, {
		x = pointtrunk.x ,
		y = pointtrunk.y,
		z = pointtrunk.z											
		}, 161.84, 
		function(callback_vehicle)
		SetVehicleLivery(callback_vehicle, 0)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
	end)
end

--[[function pizzathis02() 
    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "pizzathis" then

			--if(GetDistanceBetweenCoords(coords, spawntrunk.x, spawntrunk.y, spawntrunk.z, true) < 15.0) then
				--DrawMarker(0, spawntrunk.x, spawntrunk.y, spawntrunk.z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 255, 255, true, false, 2, nil, nil, false)
			--end
			--if(GetDistanceBetweenCoords(coords, deltrunk.x, deltrunk.y, deltrunk.z, true) <15.0) then
				--DrawMarker(0, deltrunk.x, deltrunk.y, deltrunk.z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, false, 2, nil, nil, false)
			--end

		 end
	  end
	end
  end
end]]

function pizzathis01() -- Thread de "fin de service" depuis le point rouge
	--[[if GetDistanceBetweenCoords(shop.x, shop.y, shop.z, GetEntityCoords(playerPed,true)) < 1.0 then
        DrawText3Ds(shop.x, shop.y, shop.z-0.3, "Appuyez sur ~g~E~s~ pour acheter")
        if IsControlJustPressed(1,38) then
            pizzathis_OpenMenupizzathis(3)
        end
    end]]

    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "pizzathis" and PlayerData.job.service == 1 then

		  --[[if GetDistanceBetweenCoords(spawntrunk.x, spawntrunk.y, spawntrunk.z, coords) < 3.0 then
            DrawText3Ds(spawntrunk.x, spawntrunk.y, spawntrunk.z-0.3, "Appuyez sur ~g~E~s~ pour sortir un foodtruck")
            if IsControlJustPressed(1,38) then
              pizzathis_SpawnVehicle("taco2")
			  Wait(500)
            end
          end
		  if GetDistanceBetweenCoords(deltrunk.x, deltrunk.y, deltrunk.z, coords) < 3.6 then
            DrawText3Ds(deltrunk.x, deltrunk.y, deltrunk.z-0.3, "Appuyez sur ~g~E~s~ pour ranger le foodtruck")
            if IsControlJustPressed(1,38) then
				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle = GetVehiclePedIsIn(playerPed,false)  
					ESX.Game.DeleteVehicle(vehicle)
				end
            end
          end]]

		  if GetDistanceBetweenCoords(frigo.x, frigo.y, frigo.z, GetEntityCoords(playerPed,true)) < 1.0 then
        sleepThread = 20
        DrawText3Ds(frigo.x, frigo.y, frigo.z-0.3, "Appuyez sur ~g~E~s~ pour acceder au stocks")
            if IsControlJustPressed(1,38) then
              pizzathis_OpenpizzathisStockMenu()
            end
          end

          if GetDistanceBetweenCoords(cuisine_food.x, cuisine_food.y, cuisine_food.z, GetEntityCoords(playerPed,true)) < 1.0 then
            sleepThread = 20
            DrawText3Ds(cuisine_food.x, cuisine_food.y, cuisine_food.z-0.3, "Appuyez sur ~g~E~s~ pour préparer a manger")
            if IsControlJustPressed(1,38) then
              TriggerEvent('Nebula_restaurants:OpenMenu', "pizzathis", false)
            end
          end
		  if GetDistanceBetweenCoords(cuisine_water.x, cuisine_water.y, cuisine_water.z, GetEntityCoords(playerPed,true)) < 1.0 then
        sleepThread = 20
        DrawText3Ds(cuisine_water.x, cuisine_water.y, cuisine_water.z-0.3, "Appuyez sur ~g~E~s~ pour préparer une boisson")
            if IsControlJustPressed(1,38) then
              TriggerEvent('Nebula_restaurants:OpenMenu', "pizzathis", true)
            end
          end
		  
		  if GetDistanceBetweenCoords(vestiaire.x, vestiaire.y, vestiaire.z, GetEntityCoords(playerPed,true)) < 1.0 then
        sleepThread = 20
        DrawText3Ds(vestiaire.x, vestiaire.y, vestiaire.z-0.3, "Appuyez sur ~g~E~s~ pour se changer")
            if IsControlJustPressed(1,38) then
				      pizzathis_OpenRoomMenu()
            end
          end
		  
		  if PlayerData.job.grade_name == 'boss' then
			  if GetDistanceBetweenCoords(boss.x, boss.y, boss.z, GetEntityCoords(playerPed,true)) < 1.0 then
          sleepThread = 20
          DrawText3Ds(boss.x, boss.y, boss.z-0.3, "Appuyez sur ~g~E~s~ pour acceder à la gestion entreprise")
          if IsControlJustPressed(1,38) then
            TriggerEvent('esx_society:openBossMenu', 'pizzathis', function(data, menu)
              menu.close()
            end)
          end
			  end
		  end

        end
      end
    end
end

function pizzathis_OpenRoomMenu()
  ESX.UI.Menu.CloseAll()
  local elements = {
    {label = "Vêtements", value = 'player_dressing'}
  }

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'roomZ',
    {
      title    = "Dressing",
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      if data.current.value == 'player_dressing' then

        ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)

          local elements = {}

          for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i], value = i})
          end

          table.sort(elements, function (x, y) return string.lower(x.label) < string.lower(y.label) end)

          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'player_dressing',
            {
              title    = "Vêtements",
              align = 'right',
              elements = elements,
            },
            function(data, menu)

              TriggerEvent('skinchanger:getSkin', function(skin)

                ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)

                  TriggerEvent('skinchanger:loadClothes', skin, clothes)
                  TriggerEvent('esx_skin:setLastSkin', skin)

                  TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                  end)

                end, data.current.value)

              end)

            end,
            function(data, menu)
              menu.close()
            end
          )

        end)

      end
    end,
    function(data, menu)

      menu.close()

    end
  )

end

function pizzathis_OpenJobMenu()

	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'boss_actions',
    {
      title    = 'Pizza This',
	    align = 'right',
      elements = {
      	{label = 'Facturation', value = 'billing'}
    	}
    },
    function(data, menu)

			if data.current.value == 'billing' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil then
							TriggerEvent('Core:ShowNotification', 'Montant invalide')
						else
							menu.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								TriggerEvent('Core:ShowNotification','Aucun joueur à proximité')
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_pizzathis', 'Pizza this', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Pizza This - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
							end
						end
					end,
					function(data, menu)
						menu.close()
					end)
			end
    end,
    function(data, menu)
    	menu.close()
    end
  )
end

RegisterNetEvent('esx_pizzathisjob:openMenuJob')
AddEventHandler('esx_pizzathisjob:openMenuJob', function()
	pizzathis_OpenJobMenu()
end)

xSound = exports.xsound
RegisterNetEvent("esx_pizzathisjob:playmusic")
AddEventHandler("esx_pizzathisjob:playmusic", function(data)
    local pos = vec3(804.71, -750.09, 26.78 - 0.98)
    if xSound:soundExists("pizzathis") then
      xSound:Destroy("pizzathis")
    end
    xSound:PlayUrlPos("pizzathis", data, 0.1, pos)
    xSound:Distance("pizzathis", 14)
    xSound:Position("pizzathis", pos)
end)

RegisterNetEvent("esx_pizzathisjob:pausepizzathis")
AddEventHandler("esx_pizzathisjob:pausepizzathis", function(status)
	if status == "play" then
    xSound:Resume("pizzathis")
	elseif status == "pause" then
    xSound:Pause("pizzathis")
	end
end)

RegisterNetEvent("esx_pizzathisjob:volumepizzathis")
AddEventHandler("esx_pizzathisjob:volumepizzathis", function(volume)
	print(volume/100)
    xSound:setVolume("pizzathis", volume / 100)
end)

RegisterNetEvent("esx_pizzathisjob:stoppizzathis")
AddEventHandler("esx_pizzathisjob:stoppizzathis", function()
    xSound:Destroy("pizzathis")
end)

RegisterNetEvent('esx_pizzathisjob:responseCheckForLimitation')
AddEventHandler('esx_pizzathisjob:responseCheckForLimitation', function(result)
    CanAskForNewJob = result == false
    hasCheckLimitation = true
    if result then
      TriggerEvent('Core:ShowNotification',"Vous avez atteint le quota de livraison pour aujourd'hui. Recommencez demain.")
    end
    WaitingForLimitationReach = false      
end)