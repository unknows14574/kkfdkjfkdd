local canHandsUp = true
local GUI							= {}
GUI.Time							= 0

AddEventHandler("handsup:toggle", function(param)
	canHandsUp = param
end)

function IsInVehicle()
	local ply = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ply) and IsPedInAnyVehicle(ply, false) then
		return true
	else
		return false
	end
end

function startAttitude(lib, anim)
 	Citizen.CreateThread(function()
	
	    local playerPed = GetPlayerPed(-1)
	
	    RequestAnimSet(anim)
	      
	    while not HasAnimSetLoaded(anim) do
	        Citizen.Wait(1)
	    end
	    SetPedMovementClipset(playerPed, anim, true)
	end)

end

Citizen.CreateThread(function()
	local handsup = false
	while true do
		Wait(100)
		if not IsInVehicle() then
			local lPed = GetPlayerPed(-1)
			RequestAnimDict("random@mugging3")
			if canHandsUp then
				if (IsControlPressed(1, Config.handsUP.clavier2) and (GetGameTimer() - GUI.Time) > 150) then
				--if ((IsControlPressed(1, Config.handsUP.clavier1) and IsControlPressed(1, Config.handsUP.clavier2)) and (GetGameTimer() - GUI.Time) > 150) then
				if handsup then
						if DoesEntityExist(lPed) then
							Citizen.CreateThread(function()
								RequestAnimDict("random@mugging3")
								while not HasAnimDictLoaded("random@mugging3") do
									Citizen.Wait(100)
								end

								if handsup then
									handsup = false
									ResetPedMovementClipset(lPed, 0)
									ClearPedSecondaryTask(lPed)
								end
							end)
						end
					else
						if DoesEntityExist(lPed) then
							Citizen.CreateThread(function()
								RequestAnimDict("random@mugging3")
								while not HasAnimDictLoaded("random@mugging3") do
									Citizen.Wait(100)
								end

								if not handsup then
									handsup = true
									TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
								end
							end)
						end
					end
					
					GUI.Time  = GetGameTimer()
				end

			end
		end
	end
end)