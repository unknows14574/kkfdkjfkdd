sleepThread = 1000

Citizen.CreateThread(function()
	while true do

		sleepThread = 1500

		while (PlayerData or PlayerData.job.name or PlayerData.job2.name or coords or playerPed or playerID) == nil do
			Citizen.Wait(10)
		end
		if PlayerData.job or PlayerData.job2 ~= nil then
			-- JOB 1
			if PlayerData.job.name == "ambulance" then
				ambulance03()
				ambulance04()
				AmbulanceMission()
			elseif PlayerData.job.name == "avocat" then
				Avocat03()
				Avocat04()
			elseif PlayerData.job.name == "avocat2" then
				iAvocat03()
				iAvocat04()
			elseif PlayerData.job.name == "bahama" then
				bahama03()
				bahama04()
			elseif PlayerData.job.name == "diner" then
				diner01()
				diner02()
			-- elseif PlayerData.job.name == "galaxy" then
			-- 	galaxy01()
			-- 	galaxy02()
			elseif PlayerData.job.name == "gouv" then
				gouv01()
				gouv02()
			-- elseif PlayerData.job.name == "prison" then
			-- 	prison01()
			-- 	prison02()
			elseif PlayerData.job.name == "doj" then
				doj01()
				doj02()
			elseif PlayerData.job.name == "journaliste" then
				journal03()
			elseif PlayerData.job.name == "musicrecord" then
				record03()
				record04()
			-- elseif PlayerData.job.name == "mboubar" then
			-- 	mboubar03()
			-- 	mboubar04()
			-- 	mboubar05()
			elseif PlayerData.job.name == "mecano" then
				meca03()
				meca04()
			elseif PlayerData.job.name == "mecano2" then
				mecano03()
				mecano04()
			elseif PlayerData.job.name == "henhouse" then
				henhouse03()
				henhouse04()
			elseif PlayerData.job.name == "flywheels" then
				mosley03()
				mosley04()
			elseif PlayerData.job.name == "police" then
				police04()
				police05()
				police06()
				police10()
			elseif PlayerData.job.name == "sheriff" then
				sheriff01()
				sheriff02()
			-- elseif PlayerData.job.name == "tabac" then
			-- 	tabac02()
			-- 	tabac03()
			elseif PlayerData.job.name == "upnatom" then
				upnatom01()
				upnatom03()
				upnatom04()
			elseif PlayerData.job.name == "taxi" then
				taxi01()
				taxi02()
				taxi03()
			-- elseif PlayerData.job.name == "tequi" then
			-- 	tequi01()
			-- 	tequi03()
			-- 	tequi04()
			elseif PlayerData.job.name == "event" then
				uni03()
				uni04()
			elseif PlayerData.job.name == "vigne" then
				vigne01()
				vigne02()
				vigne04()
			elseif PlayerData.job.name == "yellow" then
				yellow02()
				yellow03()
			elseif PlayerData.job.name == "coffee" then
				coffee03()
				coffee04()
			elseif PlayerData.job.name == "arcade" then
				arcade03()
				arcade04()
			-- elseif PlayerData.job.name == "gruppe6" then
			-- 	gruppe603()
			-- 	gruppe604()
			elseif PlayerData.job.name == "eightpool" then
				eightpool03()
				eightpool04()
			elseif PlayerData.job.name == "pizzathis" then
				pizzathis01()
				pizzathis03()
				pizzathis04()
			-- elseif PlayerData.job.name == "hooka" then
				-- hooka_displayMarkerAndText()
				-- hooka_keyControl()
			end

			-- JOB 2
			if PlayerData.job2.name == "ambulance" then
				ambulance03()
				ambulance04()
			elseif PlayerData.job2.name == "coffee" then
				coffee03()
				coffee04()
			elseif PlayerData.job2.name == "arcade" then
				arcade03()
				arcade04()
			-- elseif PlayerData.job2.name == "gruppe6" then
			-- 	gruppe603()
			-- 	gruppe604()
			elseif PlayerData.job2.name == "avocat" then
				Avocat03()
				Avocat04()
			elseif PlayerData.job2.name == "avocat2" then
				iAvocat03()
				iAvocat04()
			elseif PlayerData.job2.name == "bahama" then
				bahama03()
				bahama04()
			elseif PlayerData.job2.name == "diner" then
				diner01()
				diner02()
			-- elseif PlayerData.job2.name == "galaxy" then
			-- 	galaxy01()
			-- 	galaxy02()
			elseif PlayerData.job2.name == "gouv" then
				gouv01()
				gouv02()
			-- elseif PlayerData.job2.name == "prison" then
			-- 	prison01()
			-- 	prison02()
			elseif PlayerData.job2.name == "doj" then
				doj01()
				doj02()
			elseif PlayerData.job2.name == "journaliste" then
				journal03()
			elseif PlayerData.job2.name == "musicrecord" then
				record03()
				record04()
			-- elseif PlayerData.job2.name == "mboubar" then
			-- 	mboubar03()
			-- 	mboubar04()
			-- 	mboubar05()
			elseif PlayerData.job2.name == "mecano" then
				meca03()
				meca04()
			elseif PlayerData.job2.name == "mecano2" then
				mecano03()
				mecano04()
			elseif PlayerData.job2.name == "flywheels" then
				mosley03()
				mosley04()
			elseif PlayerData.job2.name == "police" then
				police04()
				police05()
				police06()
				police10()
			elseif PlayerData.job2.name == "sheriff" then
				sheriff01()
				sheriff02()
			-- elseif PlayerData.job2.name == "tabac" then
			-- 	tabac02()
			-- 	tabac03()
			elseif PlayerData.job2.name == "upnatom" then
				upnatom01()
				upnatom03()
				upnatom04()
			elseif PlayerData.job2.name == "taxi" then
				taxi01()
				taxi02()
				taxi03()
			-- elseif PlayerData.job2.name == "tequi" then
			-- 	tequi01()
			-- 	tequi03()
			-- 	tequi04()
			elseif PlayerData.job2.name == "event" then
				uni03()
				uni04()
			elseif PlayerData.job2.name == "vigne" then
				vigne01()
				vigne02()
				vigne04()
			elseif PlayerData.job2.name == "yellow" then
				yellow02()
				yellow03()
			elseif PlayerData.job2.name == "pizzathis" then
				pizzathis01()
				pizzathis03()
				pizzathis04()
			-- elseif PlayerData.job.name == "hooka" then
				-- hooka_displayMarkerAndText()
				-- hooka_keyControl()
			end

			chauffeur01()
			chauffeur03()
			chauffeur04()
			chauffeur05()
			xjobs01()
			xjobs04()
			journal04() -- Points journal pour annonces autos
			mosley09() --Point de vente auto Mosley
		end
		Citizen.Wait(sleepThread)
    end
end)

Citizen.CreateThread(function()
	while true do Citizen.Wait(500)
		while (PlayerData or PlayerData.job.name or PlayerData.job2.name or coords or playerPed or playerID) == nil do
			Citizen.Wait(10)
		end
		if PlayerData.job or PlayerData.job2 ~= nil then
			-- JOB 1 
			if PlayerData.job.name == "ambulance" then
				ambulance01()
				ambulance02()
			elseif PlayerData.job.name == "avocat" then
				Avocat01()
				Avocat02()
			elseif PlayerData.job.name == "avocat2" then
				iAvocat01()
				iAvocat02()
			elseif PlayerData.job.name == "bahama" then
				bahama01()
				bahama02()
			elseif PlayerData.job.name == "diner" then
				diner03()	
				diner04()
			-- elseif PlayerData.job.name == "galaxy" then
			-- 	galaxy03()
			-- 	galaxy04()
			elseif PlayerData.job.name == "coffee" then
				coffee01()
				coffee02()
			elseif PlayerData.job.name == "arcade" then
				arcade01()
				arcade02()
			-- elseif PlayerData.job.name == "gruppe6" then
			-- 	gruppe601()
			-- 	gruppe602()
			elseif PlayerData.job.name == "gouv" then
				gouv03()
				gouv04()
			-- elseif PlayerData.job.name == "prison" then
			-- 	prison03()
			-- 	prison04()
			elseif PlayerData.job.name == "doj" then
				doj03()
				doj04()
			elseif PlayerData.job.name == "journaliste" then
				journal01()
				journal02()
			elseif PlayerData.job.name == "musicrecord" then
				record01()
				record02()
			-- elseif PlayerData.job.name == "mboubar" then
			-- 	mboubar01()
			-- 	mboubar02()
			elseif PlayerData.job.name == "mecano" then
				meca01()
				meca02()
			elseif PlayerData.job.name == "mecano2" then
				mecano01()
				mecano02()
			elseif PlayerData.job.name == "henhouse" then
				henhouse01()
				henhouse02()
			elseif PlayerData.job.name == "flywheels" then
				mosley01()
				mosley02()
			elseif PlayerData.job.name == "police" then
				police07()
				police08()
			elseif PlayerData.job.name == "sheriff" then
				sheriff03()
				sheriff04()
				sheriff05()
			-- elseif PlayerData.job.name == "tabac" then
			-- 	tabac04()
			-- 	tabac05()
			elseif PlayerData.job.name == "taxi" then
				taxi04()
				taxi05()
			-- elseif PlayerData.job.name == "tequi" then
			-- 	tequi02()
			-- 	tequi05()
			-- 	tequi06()
			elseif PlayerData.job.name == "event" then
				uni05()
				uni06()
			elseif PlayerData.job.name == "vigne" then
				vigne03()
			elseif PlayerData.job.name == "yellow" then
				yellow04()
				yellow05()
			elseif PlayerData.job.name == "eightpool" then
				eightpool01()
				eightpool02()			
			end

			-- JOB 2
			if PlayerData.job2.name == "ambulance" then
				ambulance01()
				ambulance02()
			elseif PlayerData.job2.name == "avocat" then
				Avocat01()
				Avocat02()
			elseif PlayerData.job2.name == "avocat2" then
				iAvocat01()
				iAvocat02()
			elseif PlayerData.job2.name == "bahama" then
				bahama01()
				bahama02()
			elseif PlayerData.job2.name == "diner" then
				diner03()	
				diner04()
			-- elseif PlayerData.job2.name == "galaxy" then
			-- 	galaxy03()
			-- 	galaxy04()
			elseif PlayerData.job2.name == "gouv" then
				gouv03()
				gouv04()
			-- elseif PlayerData.job2.name == "prison" then
			-- 	prison03()
			-- 	prison04()
			elseif PlayerData.job2.name == "doj" then
				doj03()
				doj04()
			elseif PlayerData.job2.name == "journaliste" then
				journal01()
				journal02()
			elseif PlayerData.job2.name == "musicrecord" then
				record01()
				record02()
			-- elseif PlayerData.job2.name == "mboubar" then
			-- 	mboubar01()
			-- 	mboubar02()
			elseif PlayerData.job2.name == "mecano" then
				meca01()
				meca02()
			elseif PlayerData.job2.name == "mecano2" then
				mecano01()
				mecano02()
			elseif PlayerData.job2.name == "flywheels" then
				mosley01()
				mosley02()
			elseif PlayerData.job2.name == "police" then
				police07()
				police08()
			elseif PlayerData.job2.name == "sheriff" then
				sheriff03()
				sheriff04()
				sheriff05()
			-- elseif PlayerData.job2.name == "tabac" then
			-- 	tabac04()
			-- 	tabac05()
			elseif PlayerData.job2.name == "taxi" then
				taxi04()
				taxi05()
			-- elseif PlayerData.job2.name == "tequi" then
			-- 	tequi02()
			-- 	tequi05()
			-- 	tequi06()
			elseif PlayerData.job2.name == "event" then
				uni05()
				uni06()
			elseif PlayerData.job2.name == "vigne" then
				vigne03()
			elseif PlayerData.job2.name == "yellow" then
				yellow04()
				yellow05()
			elseif PlayerData.job2.name == "coffee" then
				coffee01()
				coffee02()
			elseif PlayerData.job2.name == "arcade" then
				arcade01()
				arcade02()
			-- elseif PlayerData.job2.name == "gruppe6" then
			-- 	gruppe601()
			-- 	gruppe602()
			elseif PlayerData.job.name == "eightpool" then
				eightpool01()
				eightpool02()
			end

			chauffeur02()
			xjobs03()
			mosley08() -- DrawMarker point de vente auto Mosley
			
		end
    end
end)

--solo theard
Citizen.CreateThread(function()
	while true do
		while (PlayerData or PlayerData.job.name or PlayerData.job2.name or coords or playerPed or playerID) == nil do
			Citizen.Wait(10)
		end
		local sleepThread2 = 500

		if PlayerData.job or PlayerData.job2 ~= nil then
			if IsHandcuffed or IsDragged then
				sleepThread2 = 0
				police03() -- Handcuff police & sheriff
			end
		end
		Citizen.Wait(sleepThread2)
    end
end)