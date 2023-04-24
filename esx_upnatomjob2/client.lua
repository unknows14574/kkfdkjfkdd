RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  
  if (PlayerData.job ~= nil and PlayerData.job.name == 'upnatom' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'upnatom' and PlayerData.job2.service == 1) then
	TriggerServerEvent("player:serviceOn", "upnatom")
  end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = 'upnatom',
    number     = 'upnatom',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

local nbupnatom = 0
--CONFIGURATION--

local upnatom = { x = 125.03, y = 293.93, z = 109.97} --Configuration marker prise de service
local upnatomfin = { x = 126.49, y = 297.65, z = 109.97} --Configuration marker fin de service
local spawnfaggio = { x = 416.08, y = -1925.98, z = 24.72 } --Configuration du point de spawn du faggio
local cuisine_food = { x = 89.67, y = 293.44, z = 110.23 } -- Préparation bouffe
local frigo = { x = 91.24, y = 288.55, z = 110.23 }
local cuisine_water = { x = 90.20, y = 291.13, z = 110.23 } --Préparation boisson
local boss = { x = 96.48, y = 293.98, z = 110.23 }
local vestiaire = { x = 92.05, y = 295.72, z = 110.23 }
local shop = { x = 91.20, y = 283.23, z = 109.23 } -- Shop civil

local deltrunk = { x = 409.53, y = -1932.88, z = 24.17 }
local pointtrunk = { x = 414.64, y = -1929.20, z = 24.44 }
local spawntrunk = { x = 414.64, y = -1929.20, z = 24.44 }

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
  {title="Up N Atom Burger", colour=47, id=514, x = 84.35, y = 283.91, z = 110.23}, --Configuration du point sur la carte
}

local coefflouze = 0.1 --Coeficient multiplicateur qui en fonction de la distance definit la paie

--INIT--

local isInJobPizz = false
local livr = 0
local plateab = "POPJOBS"
local isToHouse = false
local isToupnatomria = false
local paie = 0

local pourboire = 300
local posibilidad = 0
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

Citizen.CreateThread(function() --Thread d'ajout du point de la upnatom sur la carte

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

function upnatom04() --Thread lancement + livraison depuis le marker vert
    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "upnatom" and PlayerData.job.service == 1 then


    if isInJobPizz == false then

      if GetDistanceBetweenCoords(upnatom.x, upnatom.y, upnatom.z, GetEntityCoords(playerPed,true)) < 15.0 then
        DrawMarker(0,upnatom.x,upnatom.y,upnatom.z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,0,255,0, 200, 0, 0, 0, 0)
      end

      if GetDistanceBetweenCoords(upnatom.x, upnatom.y, upnatom.z, GetEntityCoords(playerPed,true)) < 1.5 then
        sleepThread = 20
        if not hasCheckLimitation then
          TriggerServerEvent('esx_upnatomjob:checkForLimitation')
        end
        WaitingForLimitationReach = true
        while WaitingForLimitationReach and not hasCheckLimitation do
          Wait(500)
        end
        if CanAskForNewJob == false then
          DrawText3Ds(upnatom.x, upnatom.y, upnatom.z-0.3, "Vous avez atteint votre quota de livraison. Revenez demain")
          do return end
        end

        DrawText3Ds(upnatom.x, upnatom.y, upnatom.z-0.3, "Appuyez sur ~g~E~s~ pour lancer les livraisons")

        if IsControlJustPressed(1,38) then
          hasCheckLimitation = false

          notif = true
          isInJobPizz = true
          isToHouse = true
          livr = math.random(1, 48)

          px = livpt[livr].x
          py = livpt[livr].y
          pz = livpt[livr].z
          distance = upnatom_round(GetDistanceBetweenCoords(upnatom.x, upnatom.y, upnatom.z, px,py,pz))
          paie = distance * coefflouze

          upnatom_goliv(livpt,livr)
          nbupnatom = math.random(1, 3)

          TriggerServerEvent("upnatom:itemadd", nbupnatom)

        end
      end
    end

    if isToHouse == true then

      destinol = livpt[livr].name

      while notif == true do

        ESX.ShowNotification("Direction : " ..destinol.. " pour livrer la commande")

        notif = false

        i = 1
      end


      DrawMarker(0,livpt[livr].x,livpt[livr].y,livpt[livr].z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,0,255,0, 200, 0, 0, 0, 0)

      if GetDistanceBetweenCoords(px,py,pz, GetEntityCoords(playerPed,true)) < 3 then
        sleepThread = 20
        DrawText3Ds(px,py,pz-0.3, "Appuyez sur ~g~E~s~ pour livrer la ~r~commande")

        if IsControlJustPressed(1,38) then

          notif2 = true
          --posibilidad = math.random(1, 100)
          afaituneupnatommin = true

          TriggerServerEvent("upnatom:itemrm")
          nbupnatom = nbupnatom - 1

          --if (posibilidad > 70) and (posibilidad < 90) then
            TriggerServerEvent("upnatom:pourboire", pourboire)

          --end

          RemoveBlip(liv)
          Wait(250)
          if nbupnatom == 0 then
            isToHouse = false
            isToupnatomria = true
          else
            isToHouse = true
            isToupnatomria = false
            livr = math.random(1, 48)

            px = livpt[livr].x
            py = livpt[livr].y
            pz = livpt[livr].z

            distance = upnatom_round(GetDistanceBetweenCoords(upnatom.x, upnatom.y, upnatom.z, px,py,pz))
            paie = distance * coefflouze

            upnatom_goliv(livpt,livr)
          end


        end
      end
    end

    if isToupnatomria == true then

      while notif2 == true do
        SetNewWaypoint(upnatom.x,upnatom.y)

        ESX.ShowNotification("Direction le Up N Atom!")
        hasCheckLimitation = false

        notif2 = false

      end

      if GetDistanceBetweenCoords(upnatom.x, upnatom.y, upnatom.z, GetEntityCoords(playerPed,true)) < 15.0 then
        DrawMarker(0,upnatom.x,upnatom.y,upnatom.z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,0,255,0, 200, 0, 0, 0, 0)
      end

      if GetDistanceBetweenCoords(upnatom.x,upnatom.y,upnatom.z, GetEntityCoords(playerPed,true)) < 3 and afaituneupnatommin == true then

        if not hasCheckLimitation then
          TriggerServerEvent('esx_upnatomjob:checkForLimitation')
        end
        WaitingForLimitationReach = true
        while WaitingForLimitationReach and not hasCheckLimitation do
          Wait(500)
        end
        if CanAskForNewJob then
          sleepThread = 20
          DrawText3Ds(upnatom.x,upnatom.y,upnatom.z-0.3, "Appuyez sur ~g~E~s~ pour récuperer la ~r~commande")
        end        

        if IsVehicleModel(GetVehiclePedIsIn(playerPed, true), GetHashKey("panto")) or IsVehicleModel(GetVehiclePedIsIn(playerPed, true), GetHashKey("faggio"))  then

          if IsControlJustPressed(1,38) then

            if upnatom_IsInVehicle() then

              afaituneupnatommin = false

              --ESX.ShowNotification("Nous vous remercions de votre travail, voici votre paie : " .. paie .. "$")

              --TriggerServerEvent("upnatom:pourboire", paie)

              isInJobPizz = true
              isToHouse = true
              livr = math.random(1, 48)

              px = livpt[livr].x
              py = livpt[livr].y
              pz = livpt[livr].z

              distance = upnatom_round(GetDistanceBetweenCoords(upnatom.x, upnatom.y, upnatom.z, px,py,pz))
              paie = distance * coefflouze

              upnatom_goliv(livpt,livr)
              nbupnatom = math.random(1, 3)

              TriggerServerEvent("upnatom:itemadd", nbupnatom)

            else

              notifmoto1 = true

              while notifmoto1 == true do

                ESX.ShowNotification("Il faut etre sur un faggio ou dans une panto pour continuer...")

                notifmoto1 = false

              end
            end
          end
        else

          notifmoto2 = true

          while notifmoto2 == true do

            ESX.ShowNotification("Il faut etre sur un faggio ou dans une panto pour continuer...")

            notifmoto2 = false

          end
        end
      end
    end
    if IsEntityDead(playerPed) then

      isInJobPizz = false
      livr = 0
      isToHouse = false
      isToupnatomria = false

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

function upnatom03() -- Thread de "fin de service" depuis le point rouge
    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "upnatom" and PlayerData.job.service == 1 then
    if isInJobPizz == true then

      if GetDistanceBetweenCoords(upnatomfin.x, upnatomfin.y, upnatomfin.z, GetEntityCoords(playerPed,true)) < 15.0 then
        DrawMarker(0,upnatomfin.x,upnatomfin.y,upnatomfin.z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3,255,0,0, 200, 0, 0, 0, 0)
      end

      if GetDistanceBetweenCoords(upnatomfin.x, upnatomfin.y, upnatomfin.z, GetEntityCoords(playerPed,true)) < 1.5 then
        sleepThread = 20
        DrawText3Ds(upnatomfin.x, upnatomfin.y, upnatomfin.z-0.3, "Appuyez sur ~g~E~s~ pour arrêter la livraison de ~r~upnatom")

        if IsControlJustPressed(1,38) then
          TriggerServerEvent('upnatom:deleteAllPizz')
          isInJobPizz = false
          livr = 0
          isToHouse = false
          isToupnatomria = false

          paie = 0
          px = 0
          py = 0
          pz = 0

          if afaituneupnatommin == true then

            local vehicleu = GetVehiclePedIsIn(playerPed, false)

            SetEntityAsMissionEntity( vehicleu, true, true )
           -- upnatom_deleteCar( vehicleu )

            ESX.ShowNotification("Merci d'avoir travaillé, bonne journée")

            --TriggerServerEvent("upnatom:paiefinale")

            SetWaypointOff()

            afaituneupnatommin = false

          else

            local vehicleu = GetVehiclePedIsIn(playerPed, false)

            SetEntityAsMissionEntity( vehicleu, true, true )
            --upnatom_deleteCar( vehicleu )

            ESX.ShowNotification("Merci quand même (pour rien), bonne journée")

          end
        end
      end
    end
  end
end
end
end

--FONCTIONS--

function upnatom_goliv(livpt,livr) -- Fonction d'ajout du point en fonction de la destination de livraison chosie
  liv = AddBlipForCoord(livpt[livr].x,livpt[livr].y, livpt[livr].z)
  SetBlipSprite(liv, 1)
  SetNewWaypoint(livpt[livr].x,livpt[livr].y)
end

function upnatom_round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function upnatom_deleteCar( entity )
  Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) ) --Native qui del le vehicule
end

function upnatom_IsInVehicle() --Fonction de verification de la presence ou non en vehicule du joueur
  local ply = playerPed
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

function upnatom_OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_upnatomjob:getStockItems', function(items)

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

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upnatom_stocks_menu', {
				title    = 'Up n Atom - Frigo',
				align = 'right',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
						title = 'quantité'
					}, function(data2, menu2)
		
						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification('quantité invalide')
						else
							menu2.close()
							menu.close()
							upnatom_OpenGetStocksMenu()

							TriggerServerEvent('esx_upnatomjob:getStockItem', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function upnatom_OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_upnatomjob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end
			
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upnatom_stocks_menu', {
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
						ESX.ShowNotification('quantité invalide')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_upnatomjob:putStockItems', itemName, count)
					end
				end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)

			menu.close()
		end)
		
		
	end)
end

function upnatom_OpenupnatomStockMenu()

	local elements = {
    {label = 'Ouvrir le stockage', value = 'get_stock'}	}
  
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upnatom_actions', {
			title    = 'Frigo',
			align = 'right',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'get_stock' then
        TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_upnatom')
        menu.close()
      end

		end, function(data, menu)

			menu.close()
		end)
end

function upnatom_SpawnVehicle(vehicle)

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

--[[function upnatom02() 
    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "upnatom" then

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

function upnatom01() -- Thread de "fin de service" depuis le point rouge
	--[[if GetDistanceBetweenCoords(shop.x, shop.y, shop.z, GetEntityCoords(playerPed,true)) < 1.0 then
        DrawText3Ds(shop.x, shop.y, shop.z-0.3, "Appuyez sur ~g~E~s~ pour acheter")
        if IsControlJustPressed(1,38) then
            upnatom_OpenMenuupnatom(3)
        end
    end]]

    if PlayerData.job ~= nil then
      if PlayerData.job.name ~= nil then
        if PlayerData.job.name == "upnatom" and PlayerData.job.service == 1 then

		  --[[if GetDistanceBetweenCoords(spawntrunk.x, spawntrunk.y, spawntrunk.z, coords) < 3.0 then
            DrawText3Ds(spawntrunk.x, spawntrunk.y, spawntrunk.z-0.3, "Appuyez sur ~g~E~s~ pour sortir un foodtruck")
            if IsControlJustPressed(1,38) then
              upnatom_SpawnVehicle("taco2")
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
              upnatom_OpenupnatomStockMenu()
            end
          end

          if GetDistanceBetweenCoords(cuisine_food.x, cuisine_food.y, cuisine_food.z, GetEntityCoords(playerPed,true)) < 1.0 then
            sleepThread = 20
            DrawText3Ds(cuisine_food.x, cuisine_food.y, cuisine_food.z-0.3, "Appuyez sur ~g~E~s~ pour préparer a manger")
            if IsControlJustPressed(1,38) then
              TriggerEvent('Nebula_restaurants:OpenMenu', "upnatom", false)
            end
          end
		  if GetDistanceBetweenCoords(cuisine_water.x, cuisine_water.y, cuisine_water.z, GetEntityCoords(playerPed,true)) < 1.0 then
        sleepThread = 20
        DrawText3Ds(cuisine_water.x, cuisine_water.y, cuisine_water.z-0.3, "Appuyez sur ~g~E~s~ pour préparer une boisson")
            if IsControlJustPressed(1,38) then
              TriggerEvent('Nebula_restaurants:OpenMenu', "upnatom", true)
            end
          end
		  
		  if GetDistanceBetweenCoords(vestiaire.x, vestiaire.y, vestiaire.z, GetEntityCoords(playerPed,true)) < 1.0 then
        sleepThread = 20
        DrawText3Ds(vestiaire.x, vestiaire.y, vestiaire.z-0.3, "Appuyez sur ~g~E~s~ pour se changer")
            if IsControlJustPressed(1,38) then
				      upnatom_OpenRoomMenu()
            end
          end
		  
		  if PlayerData.job.grade_name == 'boss' then
			  if GetDistanceBetweenCoords(boss.x, boss.y, boss.z, GetEntityCoords(playerPed,true)) < 1.0 then
          sleepThread = 20
          DrawText3Ds(boss.x, boss.y, boss.z-0.3, "Appuyez sur ~g~E~s~ pour acceder à la gestion entreprise")
          if IsControlJustPressed(1,38) then
            TriggerEvent('esx_society:openBossMenu', 'upnatom', function(data, menu)
              menu.close()
            end)
          end
			  end
		  end

        end
      end
    end
end

function upnatom_OpenRoomMenu()

ESX.UI.Menu.CloseAll()

local elements = {}

  table.insert(elements, {label = "Vêtements", value = 'player_dressing'})

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

function upnatom_OpenBillingMenu()

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing_upnatom',
    {
      title = "Montant de la facture"
    },
    function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then

        menu.close()
        if amount == nil then
            ESX.ShowNotification("Montant invalide !")
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_upnatom', "upnatom", amount)
            TriggerServerEvent('CoreLog:SendDiscordLog', "Up N Atom - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(player).."** d'un montant de `$"..amount.."`", "Yellow")
        end

      else
        ESX.ShowNotification("Aucuns joueurs à proximité !")
      end

    end,
    function(data, menu)
        menu.close()
    end
  )
end

function upnatom_OpenJobMenu()

	local elements = {}
	
	table.insert(elements, {label = "Facturation", value = "bill"})
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upnatom_foodtruck', {
			title    = 'Up N Atom - Facturation',
			align = 'right',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'bill' then
				upnatom_OpenBillingMenu()()
			end

		end, function(data, menu)

			menu.close()
		end)
end

RegisterNetEvent('esx_upnatomjob:openMenuJob')
AddEventHandler('esx_upnatomjob:openMenuJob', function()
	upnatom_OpenJobMenu()
end)

xSound = exports.xsound
RegisterNetEvent("esx_upnatomjob:playmusic")
AddEventHandler("esx_upnatomjob:playmusic", function(data)
    local pos = vec3(84.24, 286.81, 110.23)
    if xSound:soundExists("upnatom") then
      xSound:Destroy("upnatom")
    end
    xSound:PlayUrlPos("upnatom", data, 0.1, pos)
    xSound:Distance("upnatom", 14)
    xSound:Position("upnatom", pos)
end)

RegisterNetEvent("esx_upnatomjob:pauseupnatom")
AddEventHandler("esx_upnatomjob:pauseupnatom", function(status)
	if status == "play" then
    xSound:Resume("upnatom")
	elseif status == "pause" then
    xSound:Pause("upnatom")
	end
end)

RegisterNetEvent("esx_upnatomjob:volumeupnatom")
AddEventHandler("esx_upnatomjob:volumeupnatom", function(volume)
	print(volume/100)
    xSound:setVolume("upnatom", volume / 100)
end)

RegisterNetEvent("esx_upnatomjob:stopupnatom")
AddEventHandler("esx_upnatomjob:stopupnatom", function()
    xSound:Destroy("upnatom")
end)

RegisterNetEvent('esx_upnatomjob:responseCheckForLimitation')
AddEventHandler('esx_upnatomjob:responseCheckForLimitation', function(result)
    CanAskForNewJob = result == false
    hasCheckLimitation = true
    if result then
      ESX.ShowNotification("Vous avez atteint le quota de livraison pour aujourd'hui. Recommencez demain.")
    end
    WaitingForLimitationReach = false      
end)