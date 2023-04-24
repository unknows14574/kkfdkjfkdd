local tiempo = 10000 -- 1000 ms = 1s
local isTaz = false
local playerPed = nil 

Citizen.CreateThread(function()
    while(true) do
		playerPed = PlayerPedId()
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		if IsPedBeingStunned(playerPed) then
			
			SetPedToRagdoll(playerPed, 5000, 5000, 0, 0, 0, 0)
			
		end
		
		if IsPedBeingStunned(playerPed) and not isTaz then
			
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(playerPed) and isTaz then
			isTaz = false
			Wait(5000)
			
			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
			SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
	end
end)