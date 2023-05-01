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

ESX = nil
local GUI                       = {}
GUI.Time                        = 0
local PlayerData              = {}
local radioZ = false
local activescoreboard = false
local isAllowedToPed = false
local isRecording = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
  PlayerData.job2 = job
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

local playerPed = nil 
local coords = {}

Citizen.CreateThread(function()
    while(true) do
	
		playerPed = PlayerPedId()
		coords = GetEntityCoords(PlayerPedId())
		
        Citizen.Wait(1000)
    end
end)

--Notification joueur
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

--Message text joueur
function Text(text)
		SetTextColour(186, 186, 186, 255)
		SetTextFont(0)
		SetTextScale(0.378, 0.378)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(true)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.50, 0.001)
end

function GetPlayers1()
    local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(player) then
            table.insert(players, player)
        end
	end


    return players
end

function GetClosestPlayer1()
  local players = GetPlayers1()
  local closestDistance = -1
  local closestPlayer = -1
  local ply = playerPed --GetPlayerPed(-1)
  local plyCoords = coords--GetEntityCoords(ply, 0)
  
  for index,value in ipairs(players) do
    local target = GetPlayerPed(value)
    if(target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
      if(closestDistance == -1 or closestDistance > distance) then
        closestPlayer = value
        closestDistance = distance
      end
    end
  end
  
  return closestPlayer, closestDistance
end

local toggleHud = false

local cToggle = true

local peds = {"a_c_boar","a_c_cat_01","a_c_chickenhawk","a_c_chimp","a_c_chop","a_c_cormorant","a_c_cow","a_c_coyote","a_c_crow","a_c_deer","a_c_dolphin",
	"a_c_fish","a_c_hen","a_c_humpback","a_c_husky","a_c_killerwhale","a_c_mtlion","a_c_pig","a_c_pigeon","a_c_poodle","a_c_rabbit_01","a_c_rat","a_c_retriever",
	"a_c_rhesus","a_c_rottweiler","a_c_seagull","a_c_sharkhammer","a_c_sharktiger","a_c_shepherd","a_c_westy","a_f_m_beach_01","a_f_m_bevhills_01","a_f_m_bevhills_02",
	"a_f_m_bodybuild_01","a_f_m_business_02","a_f_m_downtown_01","a_f_m_eastsa_01","a_f_m_eastsa_02","a_f_m_fatbla_01","a_f_m_fatcult_01","a_f_m_fatwhite_01",
	"a_f_m_ktown_01","a_f_m_ktown_02","a_f_m_prolhost_01","a_f_m_salton_01","a_f_m_skidrow_01","a_f_m_soucent_01","a_f_m_soucent_02","a_f_m_soucentmc_01",
	"a_f_m_tourist_01","a_f_m_tramp_01","a_f_m_trampbeac_01","a_f_o_genstreet_01","a_f_o_indian_01","a_f_o_ktown_01","a_f_o_salton_01","a_f_o_soucent_01",
	"a_f_o_soucent_02","a_f_y_beach_01","a_f_y_bevhills_01","a_f_y_bevhills_02","a_f_y_bevhills_03","a_f_y_bevhills_04","a_f_y_business_01","a_f_y_business_02",
	"a_f_y_business_03","a_f_y_business_04","a_f_y_eastsa_01","a_f_y_eastsa_02","a_f_y_eastsa_03","a_f_y_epsilon_01","a_f_y_fitness_01","a_f_y_fitness_02",
	"a_f_y_genhot_01","a_f_y_golfer_01","a_f_y_hiker_01","a_f_y_hippie_01","a_f_y_hipster_01","a_f_y_hipster_02","a_f_y_hipster_03","a_f_y_hipster_04",
	"a_f_y_indian_01","a_f_y_juggalo_01","a_f_y_runner_01","a_f_y_rurmeth_01","a_f_y_scdressy_01","a_f_y_skater_01","a_f_y_soucent_01","a_f_y_soucent_02",
	"a_f_y_soucent_03","a_f_y_tennis_01","a_f_y_topless_01","a_f_y_tourist_01","a_f_y_tourist_02","a_f_y_vinewood_01","a_f_y_vinewood_02","a_f_y_vinewood_03",
	"a_f_y_vinewood_04","a_f_y_yoga_01","a_m_m_acult_01","a_m_m_afriamer_01","a_m_m_beach_01","a_m_m_beach_02","a_m_m_bevhills_01","a_m_m_bevhills_02",
	"a_m_m_business_01","a_m_m_eastsa_01","a_m_m_eastsa_02","a_m_m_farmer_01","a_m_m_fatlatin_01","a_m_m_genfat_01","a_m_m_genfat_02","a_m_m_golfer_01",
	"a_m_m_hasjew_01","a_m_m_hillbilly_01","a_m_m_hillbilly_02","a_m_m_indian_01","a_m_m_ktown_01","a_m_m_malibu_01","a_m_m_mexcntry_01","a_m_m_mexlabor_01",
	"a_m_m_og_boss_01","a_m_m_paparazzi_01","a_m_m_polynesian_01","a_m_m_prolhost_01","a_m_m_rurmeth_01","a_m_m_salton_01","a_m_m_salton_02","a_m_m_salton_03",
	"a_m_m_salton_04","a_m_m_skater_01","a_m_m_skidrow_01","a_m_m_socenlat_01","a_m_m_soucent_01","a_m_m_soucent_02","a_m_m_soucent_03","a_m_m_soucent_04",
	"a_m_m_stlat_02","a_m_m_tennis_01","a_m_m_tourist_01","a_m_m_tramp_01","a_m_m_trampbeac_01","a_m_m_tranvest_01","a_m_m_tranvest_02","a_m_o_acult_01",
	"a_m_o_acult_02","a_m_o_beach_01","a_m_o_genstreet_01","a_m_o_ktown_01","a_m_o_salton_01","a_m_o_soucent_01","a_m_o_soucent_02","a_m_o_soucent_03",
	"a_m_o_tramp_01","a_m_y_acult_01","a_m_y_acult_02","a_m_y_beach_01","a_m_y_beach_02","a_m_y_beach_03","a_m_y_beachvesp_01","a_m_y_beachvesp_02",
	"a_m_y_bevhills_01","a_m_y_bevhills_02","a_m_y_breakdance_01","a_m_y_busicas_01","a_m_y_business_01","a_m_y_business_02","a_m_y_business_03","a_m_y_cyclist_01",
	"a_m_y_dhill_01","a_m_y_downtown_01","a_m_y_eastsa_01","a_m_y_eastsa_02","a_m_y_epsilon_01","a_m_y_epsilon_02","a_m_y_gay_01","a_m_y_gay_02",
	"a_m_y_genstreet_01","a_m_y_genstreet_02","a_m_y_golfer_01","a_m_y_hasjew_01","a_m_y_hiker_01","a_m_y_hippy_01","a_m_y_hipster_01","a_m_y_hipster_02",
	"a_m_y_hipster_03","a_m_y_indian_01","a_m_y_jetski_01","a_m_y_juggalo_01","a_m_y_ktown_01","a_m_y_ktown_02","a_m_y_latino_01","a_m_y_methhead_01",
	"a_m_y_mexthug_01","a_m_y_motox_01","a_m_y_motox_02","a_m_y_musclbeac_01","a_m_y_musclbeac_02","a_m_y_polynesian_01","a_m_y_roadcyc_01","a_m_y_runner_01",
	"a_m_y_runner_02","a_m_y_salton_01","a_m_y_skater_01","a_m_y_skater_02","a_m_y_soucent_01","a_m_y_soucent_02","a_m_y_soucent_03","a_m_y_soucent_04","a_m_y_stbla_01",
	"a_m_y_stbla_02","a_m_y_stlat_01","a_m_y_stwhi_01","a_m_y_stwhi_02","a_m_y_sunbathe_01","a_m_y_surfer_01","a_m_y_vindouche_01","a_m_y_vinewood_01","a_m_y_vinewood_02",
	"a_m_y_vinewood_03","a_m_y_vinewood_04","a_m_y_yoga_01","cs_amandatownley","cs_andreas","cs_ashley","cs_bankman","cs_barry","cs_beverly","cs_brad","cs_bradcadaver",
	"cs_carbuyer","cs_casey","cs_chengsr","cs_chrisformage","cs_clay","cs_dale","cs_davenorton","cs_debra","cs_denise","cs_devin","cs_dom","cs_dreyfuss","cs_drfriedlander",
	"cs_fabien","cs_fbisuit_01","cs_floyd","cs_guadalope","cs_gurk","cs_hunter","cs_janet","cs_jewelass","cs_jimmyboston","cs_jimmydisanto","cs_joeminuteman",
	"cs_johnnyklebitz","cs_josef","cs_josh","cs_lamardavis","cs_lazlow","cs_lestercrest","cs_lifeinvad_01","cs_magenta","cs_manuel","cs_marnie","cs_martinmadrazo",
	"cs_maryann","cs_michelle","cs_milton","cs_molly","cs_movpremf_01","cs_movpremmale","cs_mrk","cs_mrs_thornhill","cs_mrsphillips","cs_natalia","cs_nervousron",
	"cs_nigel","cs_old_man1a","cs_old_man2","cs_omega","cs_orleans","cs_paper","cs_patricia","cs_priest","cs_prolsec_02","cs_russiandrunk","cs_siemonyetarian",
	"cs_solomon","cs_stevehains","cs_stretch","cs_tanisha","cs_taocheng","cs_taostranslator","cs_tenniscoach","cs_terry","cs_tom","cs_tomepsilon","cs_tracydisanto",
	"cs_wade","cs_zimbor","csb_abigail","csb_anita","csb_anton","csb_ballasog","csb_bride","csb_burgerdrug","csb_car3guy1","csb_car3guy2","csb_chef","csb_chin_goon",
	"csb_cletus","csb_cop","csb_customer","csb_denise_friend","csb_fos_rep","csb_g","csb_groom","csb_grove_str_dlr","csb_hao","csb_hugh","csb_imran","csb_janitor",
	"csb_maude","csb_mweather","csb_ortega","csb_oscar","csb_porndudes","csb_prologuedriver","csb_prolsec","csb_ramp_gang","csb_ramp_hic","csb_ramp_hipster",
	"csb_ramp_marine","csb_ramp_mex","csb_reporter","csb_roccopelosi","csb_screen_writer","csb_stripper_01","csb_stripper_02","csb_tonya","csb_trafficwarden",
	"csb_vagspeak","g_f_importexport_01","g_f_y_ballas_01","g_f_y_families_01","g_f_y_lost_01","g_f_y_vagos_01","g_m_importexport_01","g_m_m_armboss_01",
	"g_m_m_armgoon_01","g_m_m_armlieut_01","g_m_m_chemwork_01","g_m_m_chiboss_01","g_m_m_chicold_01","g_m_m_chigoon_01","g_m_m_chigoon_02","g_m_m_korboss_01",
	"g_m_m_mexboss_01","g_m_m_mexboss_02","g_m_y_armgoon_02","g_m_y_azteca_01","g_m_y_ballaeast_01","g_m_y_ballaorig_01","g_m_y_ballasout_01","g_m_y_famca_01",
	"g_m_y_famdnf_01","g_m_y_famfor_01","g_m_y_korean_01","g_m_y_korean_02","g_m_y_korlieut_01","g_m_y_lost_01","g_m_y_lost_02","g_m_y_lost_03","g_m_y_mexgang_01",
	"g_m_y_mexgoon_01","g_m_y_mexgoon_02","g_m_y_mexgoon_03","g_m_y_pologoon_01","g_m_y_pologoon_02","g_m_y_salvaboss_01","g_m_y_salvagoon_01","g_m_y_salvagoon_02",
	"g_m_y_salvagoon_03","g_m_y_strpunk_01","g_m_y_strpunk_02","hc_driver","hc_gunman","hc_hacker","ig_abigail","ig_amandatownley","ig_andreas","ig_ashley","ig_ballasog",
	"ig_bankman","ig_barry","ig_benny","ig_bestmen","ig_beverly","ig_brad","ig_bride","ig_car3guy1","ig_car3guy2","ig_casey","ig_chef","ig_chengsr","ig_chrisformage",
	"ig_clay","ig_claypain","ig_cletus","ig_dale","ig_davenorton","ig_denise","ig_devin","ig_dom","ig_dreyfuss","ig_drfriedlander","ig_fabien","ig_fbisuit_01",
	"ig_floyd","ig_g","ig_groom","ig_hao","ig_hunter","ig_janet","ig_jay_norris","ig_jewelass","ig_jimmyboston","ig_jimmydisanto","ig_joeminuteman","ig_johnnyklebitz",
	"ig_josef","ig_josh","ig_kerrymcintosh","ig_lamardavis","ig_lazlow","ig_lestercrest","ig_lifeinvad_01","ig_lifeinvad_02","ig_magenta","ig_malc","ig_manuel",
	"ig_marnie","ig_maryann","ig_maude","ig_michelle","ig_milton","ig_molly","ig_mrk","ig_mrs_thornhill","ig_mrsphillips","ig_natalia","ig_nervousron","ig_nigel",
	"ig_old_man1a","ig_old_man2","ig_omega","ig_oneil","ig_orleans","ig_ortega","ig_paper","ig_patricia","ig_priest","ig_prolsec_02","ig_ramp_gang","ig_ramp_hic",
	"ig_ramp_hipster","ig_ramp_mex","ig_roccopelosi","ig_russiandrunk","ig_screen_writer","ig_siemonyetarian","ig_solomon","ig_stevehains","ig_stretch","ig_talina",
	"ig_tanisha","ig_taocheng","ig_taostranslator","ig_tenniscoach","ig_terry","ig_tomepsilon","ig_tonya","ig_tracydisanto","ig_trafficwarden","ig_tylerdix",
	"ig_vagspeak","ig_wade","ig_zimbor","mp_f_boatstaff_01","mp_f_cardesign_01","mp_f_chbar_01","mp_f_cocaine_01","mp_f_counterfeit_01","mp_f_deadhooker",
	"mp_f_execpa_01","mp_f_forgery_01","mp_f_freemode_01","mp_f_helistaff_01","mp_f_meth_01","mp_f_misty_01","mp_f_stripperlite","mp_f_weed_01","mp_g_m_pros_01",
	"mp_headtargets","mp_m_boatstaff_01","mp_m_claude_01","mp_m_cocaine_01","mp_m_counterfeit_01","mp_m_exarmy_01","mp_m_execpa_01","mp_m_famdd_01","mp_m_fibsec_01",
	"mp_m_forgery_01","mp_m_freemode_01","mp_m_g_vagfun_01","mp_m_marston_01","mp_m_meth_01","mp_m_niko_01","mp_m_securoguard_01","mp_m_shopkeep_01","mp_m_waremech_01",
	"mp_m_weed_01","mp_s_m_armoured_01","player_one","player_two","player_zero","s_f_m_fembarber","s_f_m_maid_01","s_f_m_shop_high","s_f_m_sweatshop_01",
	"s_f_y_airhostess_01","s_f_y_bartender_01","s_f_y_baywatch_01","s_f_y_cop_01","s_f_y_factory_01","s_f_y_hooker_01","s_f_y_hooker_02","s_f_y_hooker_03",
	"s_f_y_migrant_01","s_f_y_movprem_01","s_f_y_ranger_01","s_f_y_scrubs_01","s_f_y_sheriff_01","s_f_y_shop_low","s_f_y_shop_mid","s_f_y_stripper_01",
	"s_f_y_stripper_02","s_f_y_stripperlite","s_f_y_sweatshop_01","s_m_m_ammucountry","s_m_m_armoured_01","s_m_m_armoured_02","s_m_m_autoshop_01","s_m_m_autoshop_02",
	"s_m_m_bouncer_01","s_m_m_chemsec_01","s_m_m_ciasec_01","s_m_m_cntrybar_01","s_m_m_dockwork_01","s_m_m_doctor_01","s_m_m_fiboffice_01","s_m_m_fiboffice_02",
	"s_m_m_gaffer_01","s_m_m_gardener_01","s_m_m_gentransport","s_m_m_hairdress_01","s_m_m_highsec_01","s_m_m_highsec_02","s_m_m_janitor","s_m_m_lathandy_01",
	"s_m_m_lifeinvad_01","s_m_m_linecook","s_m_m_lsmetro_01","s_m_m_mariachi_01","s_m_m_marine_01","s_m_m_marine_02","s_m_m_migrant_01","s_m_m_movalien_01",
	"s_m_m_movprem_01","s_m_m_movspace_01","s_m_m_paramedic_01","s_m_m_pilot_01","s_m_m_pilot_02","s_m_m_postal_01","s_m_m_postal_02","s_m_m_prisguard_01",
	"s_m_m_scientist_01","s_m_m_security_01","s_m_m_snowcop_01","s_m_m_strperf_01","s_m_m_strpreach_01","s_m_m_strvend_01","s_m_m_trucker_01","s_m_m_ups_01",
	"s_m_m_ups_02","s_m_o_busker_01","s_m_y_airworker","s_m_y_ammucity_01","s_m_y_armymech_01","s_m_y_autopsy_01","s_m_y_barman_01","s_m_y_baywatch_01",
	"s_m_y_blackops_01","s_m_y_blackops_02","s_m_y_busboy_01","s_m_y_chef_01","s_m_y_clown_01","s_m_y_construct_01","s_m_y_construct_02","s_m_y_cop_01","s_m_y_dealer_01",
	"s_m_y_devinsec_01","s_m_y_dockwork_01","s_m_y_doorman_01","s_m_y_dwservice_01","s_m_y_dwservice_02","s_m_y_factory_01","s_m_y_fireman_01","s_m_y_garbage",
	"s_m_y_grip_01","s_m_y_hwaycop_01","s_m_y_marine_01","s_m_y_marine_02","s_m_y_marine_03","s_m_y_mime","s_m_y_pestcont_01","s_m_y_pilot_01","s_m_y_prismuscl_01",
	"s_m_y_prisoner_01","s_m_y_ranger_01","s_m_y_robber_01","s_m_y_sheriff_01","s_m_y_shop_mask","s_m_y_strvend_01","s_m_y_swat_01","s_m_y_uscg_01","s_m_y_valet_01",
	"s_m_y_waiter_01","s_m_y_winclean_01","s_m_y_xmech_01","s_m_y_xmech_02","s_m_y_xmech_02_mp","u_f_m_corpse_01","u_f_m_miranda","u_f_m_promourn_01","u_f_o_moviestar",
	"u_f_o_prolhost_01","u_f_y_bikerchic","u_f_y_comjane","u_f_y_corpse_01","u_f_y_corpse_02","u_f_y_hotposh_01","u_f_y_jewelass_01","u_f_y_mistress","u_f_y_poppymich",
	"u_f_y_princess","u_f_y_spyactress","u_m_m_aldinapoli","u_m_m_bankman","u_m_m_bikehire_01","u_m_m_fibarchitect","u_m_m_filmdirector","u_m_m_glenstank_01",
	"u_m_m_griff_01","u_m_m_jesus_01","u_m_m_jewelsec_01","u_m_m_jewelthief","u_m_m_markfost","u_m_m_partytarget","u_m_m_prolsec_01","u_m_m_promourn_01",
	"u_m_m_rivalpap","u_m_m_spyactor","u_m_m_willyfist","u_m_o_finguru_01","u_m_o_taphillbilly","u_m_o_tramp_01","u_m_y_abner","u_m_y_antonb","u_m_y_babyd",
	"u_m_y_baygor","u_m_y_burgerdrug_01","u_m_y_chip","u_m_y_cyclist_01","u_m_y_fibmugger_01","u_m_y_guido_01","u_m_y_gunvend_01","u_m_y_hippie_01",
	"u_m_y_imporage","u_m_y_justin","u_m_y_mani","u_m_y_militarybum","u_m_y_paparazzi","u_m_y_party_01","u_m_y_pogo_01","u_m_y_prisoner_01","u_m_y_proldriver_01",
	"u_m_y_rsranger_01","u_m_y_sbike","u_m_y_staggrm_01"}

local isInModeration = false

local function CanAccessModeration()
	return exports['Nebula_Core']:CanAccessModeration()	
end

function ChangePed(Model)
	Model = GetHashKey(Model)
	if IsModelValid(Model) then
		if not HasModelLoaded(Model) then
			RequestModel(Model)
			while not HasModelLoaded(Model) do
				Citizen.Wait(0)
			end
		end
		
		SetPlayerModel(PlayerId(), Model)
		SetPedDefaultComponentVariation(PlayerPedId())
		
		SetModelAsNoLongerNeeded(Model)
	else
		ESX.ShowNotification("~r~Invalid Model!")
	end
end

function applyskin(yourskin)
	local model = GetHashKey(yourskin)

	if IsModelValid(model) then	
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(1)
		end

		SetPlayerModel(PlayerId(), model)
		SetPedDefaultComponentVariation(PlayerId())
		SetPedComponentVariation(PlayerId(), 11, 15, 0, 2)

	end
end

function DefaultPed()
	TriggerEvent('esx_showname:Disable')
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local model = nil

        if skin.sex == 0 then
          model = GetHashKey("mp_m_freemode_01")
        else
          model = GetHashKey("mp_f_freemode_01")
        end

        RequestModel(model)
        while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(1)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

        TriggerEvent('skinchanger:loadSkin', skin)
        TriggerEvent('esx:restoreLoadout')
    end)
end

function getVar1(v)
	return GetNumberOfPedDrawableVariations(playerPed, v)
end

function getVar2(v)
	return GetNumberOfPedTextureVariations(playerPed, v, GetPedDrawableVariation(playerPed, v)) - 1
end

function OpenPedMenu()
	ESX.UI.Menu.CloseAll()
	local elements702 = {}

	local txt = ""

	table.insert(elements702, {label = 'Ped d\'origine', value = 0} )

	for i = 1, #peds do
		table.insert(elements702, {label = "[" .. i .. "] " .. peds[i], value = i} )
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menu_ped',
	  {
		title    = "Ped Menu",
		align = 'right',
		elements = elements702
	  },

	  function(data, menu)

		if data.current.value == 0 then
			DefaultPed()
		else
			for a = 1, #peds do
				if a == data.current.value then
					ChangePed(peds[a])
				end
			end
		end
  
	  end,
	  function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	  end
	)
  
 end

local peds_addon = {"a_c_husky"}

function OpenPedAddOnMenu()
	ESX.UI.Menu.CloseAll()
	local elements702 = {}

	table.insert(elements702, {label = 'Ped d\'origine', value = 0} )

	for i = 1, #peds_addon do
		table.insert(elements702, {label = "[" .. i .. "] " .. peds_addon[i], value = i} )
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menuAddOn_ped',
	  {
		title    = "Ped AddOn Menu",
		align = 'right',
		elements = elements702
	  },

	  function(data, menu)

		if data.current.value == 0 then
			DefaultPed()
		else
			for a = 1, #peds_addon do
				if a == data.current.value then
					ChangePed(peds_addon[a])
				end
			end
		end
  
	  end,
	  function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	  end
	)
  
end

local weapZ = {
	{ id = "weapon_unarmed", name = "--- [Melee] ---" },
	{ id = "weapon_dagger", name = "Antique Cavalry Dagger" },
	{ id = "weapon_bat", name = "Baseball Bat" },
	--{ id = "weapon_bottle", name = "Broken Bottle" },
	{ id = "weapon_crowbar", name = "Crowbar" },
	{ id = "weapon_flashlight", name = "Flashlight" },
	{ id = "weapon_golfclub", name = "Golf Club" },
	{ id = "weapon_hammer", name = "Hammer" },
	{ id = "weapon_hatchet", name = "Hatchet" },
	{ id = "weapon_knuckle", name = "Brass Knuckles" },
	{ id = "weapon_knife", name = "Knife" },
	{ id = "weapon_machete", name = "Machete" },
	{ id = "weapon_switchblade", name = "Switchblade" },
	{ id = "weapon_nightstick", name = "Nightstick" },
	{ id = "weapon_wrench", name = "Pipe Wrench" },
	{ id = "weapon_battleaxe", name = "Battle Axe" },
	{ id = "weapon_poolcue", name = "Pool Cue" },
	{ id = "weapon_stone_hatchet", name = "Stone Hatchet" },
	{ id = "weapon_pistol", name = "Pistol" },
	--{ id = "weapon_pistol_mk2", name = "Pistol Mk II" },
	{ id = "weapon_combatpistol", name = "Combat Pistol" },
	{ id = "weapon_appistol", name = "AP Pistol" },
	{ id = "weapon_stungun", name = "Stun Gun" },
	{ id = "weapon_pistol50", name = "Pistol .50" },
	{ id = "weapon_snspistol", name = "SNS Pistol" },
	--{ id = "weapon_snspistol_mk2", name = "SNS Pistol Mk II" },
	{ id = "weapon_heavypistol", name = "Heavy Pistol" },
	{ id = "weapon_vintagepistol", name = "Vintage Pistol" },
	{ id = "weapon_flaregun", name = "Flare Gun" },
	{ id = "weapon_marksmanpistol", name = "Marksman Pistol" },
	{ id = "weapon_revolver", name = "Heavy Revolver" },
	--{ id = "weapon_revolver_mk2", name = "Heavy Revolver Mk II" },
	{ id = "weapon_doubleaction", name = "Double Action Revolver" },
	{ id = "weapon_raypistol", name = "Up-n-Atomizer" },
	{ id = "weapon_unarmed", name = "--- [Submachine Guns] ---" },
	{ id = "weapon_microsmg", name = "Micro SMG" },
	{ id = "weapon_smg", name = "SMG" },
	--{ id = "weapon_smg_mk2", name = "SMG Mk II" },
	{ id = "weapon_assaultsmg", name = "Assault SMG" },
	{ id = "weapon_combatpdw", name = "Combat PDW" },
	{ id = "weapon_machinepistol", name = "Machine Pistol" },
	{ id = "weapon_minismg", name = "Mini SMG" },
	--{ id = "weapon_raycarbine", name = "Unholy Hellbringer" },
	{ id = "weapon_unarmed", name = "--- [Shotguns] ---" },
	{ id = "weapon_pumpshotgun", name = "Pump Shotgun" },
	--{ id = "weapon_pumpshotgun_mk2", name = "Pump Shotgun Mk II" },
	{ id = "weapon_sawnoffshotgun", name = "Sawed-Off Shotgun" },
	{ id = "weapon_assaultshotgun", name = "Assault Shotgun" },
	{ id = "weapon_bullpupshotgun", name = "Bullpup Shotgun" },
	{ id = "weapon_musket", name = "Musket" },
	{ id = "weapon_heavyshotgun", name = "Heavy Shotgun" },
	{ id = "weapon_dbshotgun", name = "Double Barrel Shotgun" },
	{ id = "weapon_autoshotgun", name = "Sweeper Shotgun" },
	{ id = "weapon_unarmed", name = "--- [Assault Rifles] ---" },
	{ id = "weapon_assaultrifle", name = "Assault Rifle" },
	--{ id = "weapon_assaultrifle_mk2", name = "Assault Rifle Mk II" },
	{ id = "weapon_carbinerifle", name = "Carbine Rifle" },
	--{ id = "weapon_carbinerifle_mk2", name = "Carbine Rifle Mk II" },
	{ id = "weapon_advancedrifle", name = "Advanced Rifle" },
	{ id = "weapon_specialcarbine", name = "Special Carbine" },
	--{ id = "weapon_specialcarbine_mk2", name = "Special Carbine Mk II" },
	{ id = "weapon_bullpuprifle", name = "Bullpup Rifle" },
	--{ id = "weapon_bullpuprifle_mk2", name = "Bullpup Rifle Mk II" },
	{ id = "weapon_compactrifle", name = "Compact Rifle" },
	{ id = "weapon_unarmed", name = "--- [Light Machine Guns] ---" },
	--{ id = "weapon_mg", name = "MG" },
	--{ id = "weapon_combatmg", name = "Combat MG" },
	--{ id = "weapon_combatmg_mk2", name = "Combat MG Mk II" },
	{ id = "weapon_gusenberg", name = "Gusenberg Sweeper" },
	{ id = "weapon_unarmed", name = "--- [Sniper Rifles] ---" },
	{ id = "weapon_sniperrifle", name = "Sniper Rifle" },
	{ id = "weapon_heavysniper", name = "Heavy Sniper" },
	--{ id = "weapon_heavysniper_mk2", name = "Heavy Sniper Mk II" },
	{ id = "weapon_marksmanrifle", name = "Marksman Rifle" },
	--{ id = "weapon_marksmanrifle_mk2", name = "Marksman Rifle Mk II" },
	{ id = "weapon_unarmed", name = "--- [Heavy Weapons] ---" },
	{ id = "weapon_rpg", name = "RPG" },
	{ id = "weapon_grenadelauncher", name = "Grenade Launcher" },
	{ id = "weapon_grenadelauncher_smoke", name = "Grenade Launcher Smoke" },
	{ id = "weapon_minigun", name = "Minigun" },
	{ id = "weapon_firework", name = "Firework Launcher" },
	--{ id = "weapon_railgun", name = "Railgun" },
	--{ id = "weapon_hominglauncher", name = "Homing Launcher" },
	--{ id = "weapon_compactlauncher", name = "Compact Grenade " },
	--{ id = "weapon_rayminigun", name = "Widowmaker" },
	{ id = "weapon_unarmed", name = "--- [Throwables] ---" },
	{ id = "weapon_grenade", name = "Grenade" },
	{ id = "weapon_bzgas", name = "BZ Gas" },
	{ id = "weapon_molotov", name = "Molotov Cocktail" },
	{ id = "weapon_stickybomb", name = "Sticky Bomb" },
	{ id = "weapon_proxmine", name = "Proximity Mines" },
	{ id = "weapon_snowball", name = "Snowballs" },
	{ id = "weapon_pipebomb", name = "Pipe Bombs" },
	{ id = "weapon_ball", name = "Baseball" },
	{ id = "weapon_smokegrenade", name = "Tear Gas" },
	{ id = "weapon_flare", name = "Flare" },
	{ id = "weapon_unarmed", name = "--- [Miscellaneous] ---" },
	{ id = "weapon_petrolcan", name = "Jerry Can" },
	{ id = "gadget_parachute", name = "Parachute" },
	{ id = "weapon_fireextinguisher", name = "Fire Extinguisher" },
}

function OpenSetJobMenu(target)

	local elements = {}
	
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'setjobZ',
		{
			title    = 'Change Job',
			align = 'right',
			elements = {
				{label = 'RSA', value = 'unemployed', grade = 0},
				{label = 'RSA 2', value = 'unemployed2', grade = 0},
				
				{label = 'LSPD - Recrue', value = 'police', grade = 0},
				{label = 'LSPD - Officier', value = 'police', grade = 1},
				{label = 'LSPD - Sergent', value = 'police', grade = 2},
				{label = 'LSPD - Lieutenant', value = 'police', grade = 3},
				{label = 'LSPD - Capitaine', value = 'police', grade = 4},
				{label = 'LSPD - Commandant', value = 'police', grade = 5},
				
				{label = 'Ambulance - Ambulancier', value = 'ambulance', grade = 0},
				{label = 'Ambulance - Medecin', value = 'ambulance', grade = 1},
				{label = 'Ambulance - Medecin-chef', value = 'ambulance', grade = 2},
				{label = 'Ambulance - Chirurgien', value = 'ambulance', grade = 3},
				
				{label = 'Mécano - Recrue', value = 'mecano', grade = 0},
				{label = 'Mécano - Novice', value = 'mecano', grade = 1},
				{label = 'Mécano - Experimente', value = 'mecano', grade = 2},
				{label = 'Mécano - Chef d\'équipe', value = 'mecano', grade = 3},
				{label = 'Mécano - Patron', value = 'mecano', grade = 4},
				
				{label = 'Taxi - Recrue', value = 'taxi', grade = 0},
				{label = 'Taxi - Novice', value = 'taxi', grade = 1},
				{label = 'Taxi - Experimente', value = 'taxi', grade = 2},
				{label = 'Taxi - Uber', value = 'taxi', grade = 3},
				{label = 'Taxi - Patron', value = 'taxi', grade = 4},
				
				{label = 'Unicorn - Barman', value = 'event', grade = 0},
				{label = 'Unicorn - Danseur', value = 'event', grade = 1},
				{label = 'Unicorn - Co-gérant', value = 'event', grade = 2},
				{label = 'Unicorn - Gérant', value = 'event', grade = 3},
				
				--{label = 'Chez Marcus - Vendeur', value = 'epicerie', grade = 0},
				--{label = 'Chez Marcus - Co-gérant', value = 'epicerie', grade = 1},
				--{label = 'Chez Marcus - Patron', value = 'epicerie', grade = 2},
				
				-- {label = 'Palace - Vigile', value = 'palace', grade = 0},
				-- {label = 'Palace - Barman', value = 'palace', grade = 1},
				-- {label = 'Palace - DJ', value = 'palace', grade = 2},
				-- {label = 'Palace - Co-gérant', value = 'palace', grade = 3},
				-- {label = 'Palace - Patron', value = 'palace', grade = 4},
				
				{label = 'Cabinet L.&Associés - Avocat', value = 'avocat2', grade = 0},
				{label = 'Cabinet L.&Associés - Gérant', value = 'avocat2', grade = 1},
				
				{label = 'Cabinet Harris - Avocat', value = 'avocat', grade = 0},
				{label = 'Cabinet Harris - Gérant', value = 'avocat', grade = 1},
				
				--[[{label = 'Agent Immo - Location', value = 'realestateagent', grade = 0},
				{label = 'Agent Immo - Vendeur', value = 'realestateagent', grade = 1},
				{label = 'Agent Immo - Gestion', value = 'realestateagent', grade = 2},
				{label = 'Agent Immo - Patron', value = 'realestateagent', grade = 3},]]
				
				--[[{label = 'Banque - Conseiller', value = 'banker', grade = 0},
				{label = 'Banque - Banquier', value = 'banker', grade = 1},
				{label = 'Banque - Patron', value = 'banker', grade = 2},]]
				
				{label = 'Journaliste - Stagiaire', value = 'journaliste', grade = 0},
				{label = 'Journaliste - Reporter', value = 'journaliste', grade = 1},
				{label = 'Journaliste - Enquêteur', value = 'journaliste', grade = 2},
				{label = 'Journaliste - Rédac\' chef', value = 'journaliste', grade = 3},
				
				--[[{label = 'Raffineur - Intérimaire', value = 'fuel', grade = 0},
				{label = 'Raffineur - Employé', value = 'fuel', grade = 1},
				{label = 'Raffineur - Chef d\'équipe', value = 'fuel', grade = 2},
				{label = 'Raffineur - Patron', value = 'fuel', grade = 3},
				
				
				
				{label = 'Eboueur - Intérimaire', value = 'garbage', grade = 0},
				{label = 'Eboueur - Employé', value = 'garbage', grade = 1},
				{label = 'Eboueur - Chef d\'équipe', value = 'garbage', grade = 2},
				{label = 'Eboueur - Patron', value = 'garbage', grade = 3},
				
				{label = 'GOV - Agent', value = 'gouv', grade = 0},
				{label = 'GOV - Gouverneur', value = 'gouv', grade = 1},]]
				
				{label = 'FIB - Recrue', value = 'fib', grade = 0},
				{label = 'FIB - Agent', value = 'fib', grade = 1},
				{label = 'FIB - Agent Spécial', value = 'fib', grade = 2},
				{label = 'FIB - Directeur', value = 'fib', grade = 3},
				
				{label = 'Vigneron - Intérimaire', value = 'vignerons', grade = 0},
				{label = 'Vigneron - Employé', value = 'vignerons', grade = 1},
				{label = 'Vigneron - Chef d\'équipe', value = 'vignerons', grade = 2},
				{label = 'Vigneron - Patron', value = 'vignerons', grade = 3},
				
				{label = 'Tabac - Employé', value = 'tabac', grade = 0},
				{label = 'Tabac - Chef d\'équipe', value = 'tabac', grade = 1},
				{label = 'Tabac - Patron', value = 'tabac', grade = 2},
				
				--{label = 'Brinks - Employé', value = 'brinks', grade = 0},
				--{label = 'Brinks - Chef d\'équipe', value = 'brinks', grade = 1},
				--{label = 'Brinks - Co-Patron', value = 'brinks', grade = 2},
				--{label = 'Brinks - Patron', value = 'brinks', grade = 3},
				
				--{label = 'Lost - Employé', value = 'lost', grade = 0},
				--{label = 'Lost - Chef d\'équipe', value = 'lost', grade = 1},
				--{label = 'Lost - Co-Patron', value = 'lost', grade = 2},
				--{label = 'Lost - Patron', value = 'lost', grade = 3},
				
				--{label = 'Beer & Love - Intérimaire', value = 'beer', grade = 0},
				--{label = 'Beer & Love - Employé', value = 'beer', grade = 1},
				--{label = 'Beer & Love - Chef d\'équipe', value = 'beer', grade = 2},
				--{label = 'Beer & Love - Patron', value = 'beer', grade = 3},
				
				--{label = 'Fishing Compagny - Intérimaire', value = 'fisherman', grade = 0},
				--{label = 'Fishing Compagny - Employé', value = 'fisherman', grade = 1},
				--{label = 'Fishing Compagny - Chef d\'équipe', value = 'fisherman', grade = 2},
				--{label = 'Fishing Compagny - Patron', value = 'fisherman', grade = 3},
				
				--{label = 'Bijoutier - Intérimaire', value = 'bijoutier', grade = 0},
				--{label = 'Bijoutier - Employé', value = 'bijoutier', grade = 1},
				--{label = 'Bijoutier - Chef d\'équipe', value = 'bijoutier', grade = 2},
				--{label = 'Bijoutier - Patron', value = 'bijoutier', grade = 3},
				
				--{label = 'Armurerie - Employé', value = 'armurerie', grade = 0},
				--{label = 'Armurerie - Chef d\'équipe', value = 'armurerie', grade = 1},
				--{label = 'Armurerie - Patron', value = 'armurerie', grade = 2},
				
				{label = 'Ballas - Guetteur', value = 'ballas', grade = 0},
				{label = 'Ballas - Voyou', value = 'ballas', grade = 1},
				{label = 'Ballas - Gangstar', value = 'ballas', grade = 2},
				{label = 'Ballas - Boss ', value = 'ballas', grade = 3},
				
				{label = 'SAB - Guetteur', value = 'SAB', grade = 0},
				{label = 'SAB - Voyou', value = 'SAB', grade = 1},
				{label = 'SAB - Gangstar', value = 'SAB', grade = 2},
				{label = 'SAB - Boss ', value = 'SAB', grade = 3},
				
				{label = 'Mafia madrazo - Hommes de mains', value = 'madrazo', grade = 0},
				{label = 'Mafia madrazo - Lieutenant', value = 'madrazo', grade = 1},
				{label = 'Mafia madrazo - Capo', value = 'madrazo', grade = 2},
				{label = 'Mafia madrazo - Conseiller ', value = 'madrazo', grade = 3},
				{label = 'Mafia madrazo - Parrain ', value = 'madrazo', grade = 4},
				
				{label = 'Mafia Albanaise - Hommes de mains', value = 'albanaise', grade = 0},
				{label = 'Mafia Albanaise - Lieutenant', value = 'albanaise', grade = 1},
				{label = 'Mafia Albanaise - Capo', value = 'albanaise', grade = 2},
				{label = 'Mafia Albanaise - Conseiller ', value = 'albanaise', grade = 3},
				{label = 'Mafia Albanaise - Parrain ', value = 'albanaise', grade = 4},
				
				{label = 'Bikers - Boull aka', value = 'bikers', grade = 0},
				{label = 'Bikers - Prospect', value = 'bikers', grade = 1},
				{label = 'Bikers - Full Patch', value = 'bikers', grade = 2},
				{label = 'Bikers - Road Captain ', value = 'bikers', grade = 3},
				{label = 'Bikers - Sgt At Arms ', value = 'bikers', grade = 4},
				{label = 'Bikers - Vice Président ', value = 'bikers', grade = 5},
				{label = 'Bikers - Président ', value = 'bikers', grade = 6},

				{label = 'Sightless Skulls - Prospect', value = 'bikers4', grade = 0},
				{label = 'Sightless Skulls - Full Patch', value = 'bikers4', grade = 1},
				{label = 'Sightless Skulls - Road Captain', value = 'bikers4', grade = 2},
				{label = 'Sightless Skulls - TailGunner ', value = 'bikers4', grade = 3},
				{label = 'Sightless Skulls - Trésorier ', value = 'bikers4', grade = 4},
				{label = 'Sightless Skulls - Sgt At Arms ', value = 'bikers4', grade = 5},
				{label = 'Sightless Skulls - Lieutenant ', value = 'bikers4', grade = 6},
				{label = 'Sightless Skulls - Vice Président(e) ', value = 'bikers4', grade = 7},
				{label = 'Sightless Skulls - Président(e) ', value = 'bikers4', grade = 8},

				{label = 'Mafia Calabraise - Soldat', value = 'mafiacala', grade = 0},
				{label = 'Mafia Calabraise - Capos', value = 'mafiacala', grade = 1},
				{label = 'Mafia Calabraise - SousBoss', value = 'mafiacala', grade = 2},
				{label = 'Mafia Calabraise - Consigliere', value = 'mafiacala', grade = 3},
				{label = 'Mafia Calabraise - Parrain', value = 'mafiacala', grade = 4},

				{label = 'Loco Syndicate - Recrue', value = 'locosyndicate', grade = 0},
				{label = 'Loco Syndicate - Homme de main', value = 'locosyndicate', grade = 1},
				{label = 'Loco Syndicate - Responsable', value = 'locosyndicate', grade = 2},
				{label = 'Loco Syndicate - Bras Droit', value = 'locosyndicate', grade = 3},
				{label = 'Loco Syndicate - Boss', value = 'locosyndicate', grade = 4},
				
				{label = 'VCF - Homme de main', value = 'VCF', grade = 0},
				{label = 'VCF - Chef homme de main', value = 'VCF', grade = 1},
				{label = 'VCF - Officier', value = 'VCF', grade = 2},
				{label = 'VCF - Bras droit', value = 'VCF', grade = 3},
				{label = 'VCF - Boss', value = 'VCF', grade = 4},
				
				{label = 'Vagos - Pequeño', value = 'vagos', grade = 0},
				{label = 'Vagos - Guerrero', value = 'vagos', grade = 1},
				{label = 'Vagos - Jefe', value = 'vagos', grade = 2},
				
				{label = 'L\'organisation - Recrue', value = 'orga', grade = 0},
				{label = 'L\'organisation - Membre', value = 'orga', grade = 1},
				{label = 'L\'organisation - Lieutenant', value = 'orga', grade = 2},
				{label = 'L\'organisation - Boss ', value = 'orga', grade = 3},
				
				{label = 'Ghost - Hommes de main', value = 'bratva', grade = 0},
				{label = 'Ghost - Soldats', value = 'bratva', grade = 1},
				{label = 'Ghost - Bras droit', value = 'bratva', grade = 2},
				{label = 'Ghost - Chef', value = 'bratva', grade = 3},
				
				{label = 'Sheriff - Depute probatoire', value = 'sheriff', grade = 0},
				{label = 'Sheriff - Depute', value = 'sheriff', grade = 1},
				{label = 'Sheriff - Sergent', value = 'sheriff', grade = 2},
				{label = 'Sheriff - Lieutenant', value = 'sheriff', grade = 3},
				{label = 'Sheriff - Capitaine', value = 'sheriff', grade = 4},
				{label = 'Sheriff - Sheriff Adjoint', value = 'sheriff', grade = 5},
				{label = 'Sheriff - Sous-Sheriff', value = 'sheriff', grade = 6},
				{label = 'Sheriff - Sheriff', value = 'sheriff', grade = 7},

				{label = '8 Pool Bar - Vigile', value = 'eightpool', grade = 0},
				{label = '8 Pool Bar - Barman', value = 'eightpool', grade = 1},
				{label = '8 Pool Bar -Gestionnaire', value = 'eightpool', grade = 2},
				{label = '8 Pool Bar - Gérant', value = 'eightpool', grade = 3}
				
			  }
		},
    function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'setjobZ_change', {
			  title    = data.current.label,
			  --align    = 'bottom-right',
			  align = 'right',
			  elements = {
				{label = 'Job #1', value = 1},
				{label = 'Job #2', value = 2}
			  }
			}, 
			function(data2, menu2)
			
			  TriggerServerEvent('AdminMenu:setjob', data2.current.value, data.current.label, data.current.value, data.current.grade, target)
		
			  menu2.close()
			end, 
			
			function(data2, menu2)
			  menu2.close()
			end)
	  

		end,
		function(data, menu)
			menu.close()
		end
	)	

end

function OpenNeonLights()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'NeonLights',
    {
      title    = 'Néon Lights',
	  align = 'right',
      elements = {
		{label = "Blanc", value = "White", options = {r = 255, g = 255, b = 255}},
		{label = "Bleu", value = "Blue", options = {r = 2, g = 21, b = 255}},
		{label = "Bleu turquoise", value = "Blue_turquoise", options = {r = 110, g = 220, b = 217}},
		{label = "Bleu éléctrique", value = "Electric_Blue", options = {r = 3, g = 83, b = 255}},		
		{label = "Jaune", value = "Yellow", options = {r = 255, g = 255, b = 0}},
		{label = "Lumière noire", value = "Blacklight", options = {r = 15, g = 3, b = 255}},
		{label = "Or", value = "Golden_Shower", options = {r = 255, g = 150, b = 0}},
		{label = "Orange", value = "Orange", options = {r = 255, g = 62, b = 0}},
		{label = "Rouge", value = "Red", options = {r = 255, g = 1, b = 1}},
		{label = "Rose", value = "Pony_Pink", options = {r = 255, g = 50, b = 100}},
		{label = "Rose profond", value = "Hot_Pink", options = {r = 255, g = 5, b = 190}},
		{label = "Vert menthe", value = "Mint_Green", options = {r = 0, g = 255, b = 140}},
		{label = "Vert citron", value = "Lime_Green", options = {r = 94, g = 255, b = 1}},
		{label = "Violet", value = "Purple", options = {r = 35, g = 1, b = 255}}
      }
    },
    function(data, menu)
	
	TriggerEvent('NeonLights', data.current.options)

    end,
    function(data, menu)
		OpenVehiculeMenu()
      	menu.close()
    end
  )

end

function OpenXenonLights()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'XenonLights',
    {
      title    = 'Xenon Lights',
	  align = 'right',
      elements = {
		{label = "Défaut", value = "Default", options = 13},
		{label = "Blanc", value = "White", options = 0},
		{label = "Bleu", value = "Blue", options = 1},
		{label = "Bleu éléctrique", value = "Electric_Blue", options = 2},
		{label = "Jaune", value = "Yellow", options = 5},
		{label = "Lumière noire", value = "Blacklight", options = 12},
		{label = "Or", value = "Golden_Shower", options = 6},
		{label = "Orange", value = "Orange", options = 7},
		{label = "Rouge", value = "Red", options = 8},
		{label = "Rose", value = "Pony_Pink", options = 9},
		{label = "Rose profond", value = "Hot_Pink", options = 10},
		{label = "Vert menth", value = "Mint_Green", options = 3},
		{label = "Vert citron", value = "Lime_Green", options = 4},
		{label = "Violet", value = "Purple", options = 11}
      }
    },
    function(data, menu)
	
	TriggerEvent('XenonLights', data.current.options)

    end,
    function(data, menu)
		OpenVehiculeMenu()
      	menu.close()
    end)
end



function OpenWeapMenu(target)
	ESX.UI.Menu.CloseAll()
	local elements7 = {}

	for i = 1, #weapZ do
		table.insert(elements7, {label = weapZ[i].name, value = weapZ[i].id} )
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menuweapZ',
	  {
		title    = "Weapon Menu",
		align = 'right',
		elements = elements7
	  },

	  function(data, menu)

		TriggerServerEvent('AdminMenu:giveWeapon', data.current.value, 255, target)
		
	  end,
	  function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	  end
	)
  
end




function OpenSpectateMenu()
	local elements = {}

	--[[local infos = {}
	--onesync --for i = 0, 255 do
	for _, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			table.insert(infos, {name = GetPlayerName(i), id = GetPlayerServerId(i)})
		end
	end]]

	table.insert(elements, {label = 'Quitter le mode spectate', value = 0, name = "0"} )

	--[[for v, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			local idServ = GetPlayerServerId(i)
			local PlayerName = GetPlayerName(i)
			table.insert(elements, {label = "[" .. idServ .. "] " .. PlayerName, value = idServ, name= PlayerName})
		end
	end]]

	

	ESX.TriggerServerCallback('esx_jobcounter:returnTableMetier',function(valid)
		for k, v in pairs(valid) do
			--print(v.firstname .. " " .. v.lastname .. v.id)
			table.insert(elements, {label = "[" .. v.id .. "] " .. v.firstname .. " " .. v.lastname, name = v.firstname, value = v.id})
		end
	
	
		local function cmp(a, b)
			a = tostring(a.name)
			b = tostring(b.name)
			local patt = '^(.-)%s*(%d+)$'
			local _,_, col1, num1 = a:find(patt)
			local _,_, col2, num2 = b:find(patt)
			if (col1 and col2) and col1 == col2 then
			return tonumber(num1) < tonumber(num2)
			end
			return a < b
		end

		table.sort(elements, cmp)

		--[[for i, v in ipairs(infos) do
			if v.name ~= nil and v.id ~= nil and v.name ~= "**Invalid**" then
				table.insert(elements, {label = "[" .. v.id .. "] " .. v.name, value = v.id})
			end
		end]]
		

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'pspec',
			{
				title    = 'Spectate Menu',
				align = 'right',
				elements = elements,
			},
			function(data, menu)

			if data.current.value == 0 then
				elements = {}
				TriggerEvent('esx_spectate:iReset')

				ESX.UI.Menu.CloseAll()
			else
				elements = {}
				TriggerEvent('Core:moderation:spectate', data.current.value)

			end
		
			end,
			
			function(data, menu)
				menu.close()
			end)	
	end, "tabName", "players")

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

function OpenAdminActionMenu(player)

    ESX.TriggerServerCallback('AdminMenu:getOtherPlayerData', function(data)

	  local jobLabel    = nil
	  local jobLabel2    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil
	  local Money		= 0
	  local Bank		= 0
	  local blackMoney	= 0
	  local Inventory	= nil
	  
    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
	end
	
	local jobservice, jobservice2 = "Hors Service", "Hors Service"
	if data.job.service == 1 then
		jobservice = "En Service"
	end
	if data.job2.service == 1 then
		jobservice2 = "En Service"
	end

	  if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel =  jobservice .. ' Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel =  jobservice .. ' Job : ' .. data.job.label
	  end
	  
	  if data.job2.grade_label ~= nil and  data.job2.grade_label ~= '' then
        jobLabel2 = jobservice2 .. ' Job2 : ' .. data.job2.label .. ' - ' .. data.job2.grade_label
      else
        jobLabel2 =  jobservice2 .. ' Job2 : ' .. data.job2.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Male'
        else
          sex = 'Female'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end
	  
	  if data.money ~= nil then
		Money = data.money
		else
		Money = 'No Data'
	  end

 	  if data.bank ~= nil then
		Bank = data.bank
		else
		Bank = 'No Data'
	  end
	  
      if data.dob ~= nil then
        dobLabel = 'DOB : ' .. data.dob
      else
        dobLabel = 'DOB : Unknown'
      end

      if data.height ~= nil then
        heightLabel = 'Height : ' .. data.height
      else
        heightLabel = 'Height : Unknown'
      end

      if data.name ~= nil then
        idLabel = 'Steam ID : ' .. data.name
      else
        idLabel = 'Steam ID : Unknown'
      end
	  
      local elements = {
        {label = 'Name: ' .. data.firstname .. " " .. data.lastname, value = nil},
        {label = 'Money: '.. data.money, value = nil},
        {label = 'Bank: '.. data.bank, value = nil},
        {label = 'Black Money: '.. blackMoney, value = nil, itemType = 'item_account', amount = blackMoney},
		{label = jobLabel,    value = nil},
		{label = jobLabel2,    value = nil},
        {label = idLabel,     value = nil},
    }
	
    table.insert(elements, {label = '--- Inventory ---', value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = data.inventory[i].label .. ' x ' .. data.inventory[i].count,
          value          = nil,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end
	
    table.insert(elements, {label = '--- Weapons ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = ESX.GetWeaponLabel(data.weapons[i].name),
        value          = nil,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
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
          title    = 'Player Control',
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


function OpenModMenu(mod)
	local elements = {}

	--local infos = {}
	--onesync --for i = 0, 255 do
	--[[for _, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			table.insert(infos, {name = GetPlayerName(i), id = GetPlayerServerId(i)})
		end
	end]]

	ESX.TriggerServerCallback('esx_jobcounter:returnTableMetier',function(valid)
		for k, v in pairs(valid) do
			--print(v.firstname .. " " .. v.lastname .. v.id)
			table.insert(elements, {label = "[" .. v.id .. "] " .. v.firstname .. " " .. v.lastname, name = v.firstname, lastname = v.lastname, value = v.id})
		end

		local function cmp(a, b)
			a = tostring(a.name)
			b = tostring(b.name)
			local patt = '^(.-)%s*(%d+)$'
			local _,_, col1, num1 = a:find(patt)
			local _,_, col2, num2 = b:find(patt)
			if (col1 and col2) and col1 == col2 then
			return tonumber(num1) < tonumber(num2)
			end
			return a < b
		end

		table.sort(elements, cmp)

		--[[for _,v in pairs(infos) do
			if v.name ~= nil and v.id ~= nil and v.name ~= "**Invalid**" then
				table.insert(elements, {label = "[" .. v.id .. "] " .. v.name, value = v.id})
			end
		end]]

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'modlist',
			{
				title    = mod,
				align = 'right',
				elements = elements,
			},
			function(data, menu)

				if mod == "SKIN" then
					TriggerEvent('esx_skin:openSaveableMenu', data.current.value)
				elseif mod == "Money Bank" then
					admin_give_bank(data.current.value)
				elseif mod == "Money Cash" then
					admin_give_money(data.current.value)
				elseif mod == "Money Dirty" then
					admin_give_dirty(data.current.value)
				elseif mod == "TP2P" then
					admin_tp_toplayer(data.current.value)
				elseif mod == "TP2M" then
					admin_tp_playertome(data.current.value)
				elseif mod == "Player" then
					TriggerServerEvent('core_inventory:custom:searchPlayer', data.current.value)
				elseif mod == "Weapon" then
					OpenWeapMenu(data.current.value)
				elseif mod == "Item" then
					TriggerEvent('esx_vehicleshop:OpenItemMenu', data.current.value)
				elseif mod == "Set Job" then
					OpenSetJobMenu(data.current.value)
				elseif mod == "Ban" then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ban_Z',
						{
							title = "Raison du ban"
						}, 	
						function(data2, menu2)

						local raison = data2.value

						if raison == nil then
							ESX.ShowNotification("Merci de mettre une raison")
						else
							menu2.close()
							local identifier_unwhi = GetPlayerIdentifier(data.current.value)
							TriggerServerEvent('whitelist:unwhitelist', identifier_unwhi)
							TriggerServerEvent('bot:eBan', data.current.value, raison)
							TriggerServerEvent('AdminMenu:banned', data.current.value, raison)
						end

						end, function(data2, menu2)
						menu2.close()
					end)
					
					
				elseif mod == "Kick" then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kick_Z',
						{
							title = "Raison du kick"
						}, 	
						function(data2, menu2)

						local raison = data2.value

						if raison == nil then
							ESX.ShowNotification("Merci de mettre une raison")
						else
							menu2.close()
							TriggerServerEvent('bot:eKick', data.current.value, raison)
						end

						end, function(data2, menu2)
						menu2.close()
					end)
					
					
				elseif mod == "Reset" then
					local elements2 = {}
					table.insert(elements2, {label = "Non je ne veux pas reset "..data.current.label, value = 'no'})
					table.insert(elements2, {label = "Oui je veux reset "..data.current.label, value = 'yes'})

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'modlistconfirmreset',
						{
							title    = "Etes-vous sur de reset ?",
							align = 'right',
							elements = elements2,
						},
						function(data2, menu2)
							if data2.current.value == 'yes' then
								
								-- ExecuteCommand(('clearinventory %s'):format(data.current.value)) -- To uncomment if need
								TriggerServerEvent('AdminMenu:resetPlayer', data.current.value, data.current.label)
								menu2.close()
							else
								TriggerEvent('Core:ShowNotification', 'Vous n\'avez ~r~pas ~y~reinitialisé ~b~'..data.current.label)
								menu2.close()
							end
						end,
						
						function(data2, menu2)
							menu2.close()
						end)
				elseif mod == "wl" then
					TriggerServerEvent('AdminMenu:whitelist', data.current.value)
				elseif mod == "vip" then
					TriggerServerEvent('AdminMenu:vip', data.current.value)
				elseif mod == "RWeap" then
					TriggerServerEvent('core_inventory:custom:removeAllWeaponEquiped', data.current.value)
					-- RemoveAllPedWeapons(data.current.value, true)
				elseif mod == "Ritems" then
					TriggerServerEvent('core_inventory:custom:searchPlayer', data.current.value)
				elseif mod == "unwhitelist" then
					local identifier_unwhi = GetPlayerIdentifier(data.current.value)
					TriggerServerEvent('whitelist:unwhitelist', identifier_unwhi)
				end
		
			end,
			
			function(data, menu)
				menu.close()
			end)
	end, "tabName", "players")
end


function OpenBodySearchMenu(player)

	ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('esx_menuperso:getOtherPlayerData', function(data)
  
	  local elements = {}

	  local blackMoney = 0

	  for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'black_money' then
		 	blackMoney = data.accounts[i].money
		end
	  end
	  

	  table.insert(elements, {
		label          = 'Confisquer argent sale : $' .. blackMoney,
		value          = 'black_money',
		itemType       = 'item_account',
		amount         = blackMoney
	  })

	  table.insert(elements, {
		label          = 'Confisquer argent propre : $' .. data.money,
		value          = 'money',
		itemType       = 'item_money',
		amount         = data.money
	  })

	  table.insert(elements, {
		label          = 'Confisquer argent banque : $' .. data.bank,
		value          = 'bank',
		itemType       = 'item_account',
		amount         = data.bank
	  })
  
	  table.insert(elements, {label = '--- Armes ---', value = nil})
  
	  for i=1, #data.weapons, 1 do
		table.insert(elements, {
		  label          = 'Confisquer ' .. (ESX.GetWeaponLabel(data.weapons[i].name) or "Undefined"),
		  value          = data.weapons[i].name,
		  itemType       = 'item_weapon',
		  amount         = data.ammo,
		})
	  end
  
	  table.insert(elements, {label = '--- Inventaire ---', value = nil})
  
	  for i=1, #data.inventory, 1 do
		if data.inventory[i].count > 0 then
		  table.insert(elements, {
			label          = 'Confisquer x' .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
			value          = data.inventory[i].name,
			itemType       = 'item_standard',
			amount         = data.inventory[i].count,
		  })
		end
	  end
  
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'retier_item_menu',
		{
		  title    = "Retirer items",
		  align = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  local itemType = data.current.itemType
		  local itemName = data.current.value
		  local amount   = data.current.amount
  
		  if data.current.value ~= nil then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'montant_retirer',
				{
					title = "Nombre à retirer"
				}, 	
				function(data2, menu2)
				
				local montant = tonumber(data2.value)

				if itemType == "item_weapon" then
					menu2.close()
					TriggerServerEvent('esx_menuperso:confiscatePlayerItem', player, itemType, itemName, amount)
					OpenBodySearchMenu(player)
				elseif montant == nil then
					ESX.ShowNotification("Merci de mettre un montant")
				else
					menu2.close()
					TriggerServerEvent('esx_menuperso:confiscatePlayerItem', player, itemType, itemName, montant)
					OpenBodySearchMenu(player)
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
  
	end, player)
  
end


function OpenBannedList()

	ESX.UI.Menu.CloseAll()

	local elements = {}

	  ESX.TriggerServerCallback('AdminMenu:GetBanned', function(wl)
  
		  for _,v in pairs(wl) do
			  if v.banned == 1 then
				table.insert(elements, {label = v.name, value = v})
			  end
		  end
  
		  ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'banlist',
		  {
			  title    = 'Débannir une personne',
			  align = 'right',
			  elements = elements,
		  },
	  function(data, menu)
			
			ESX.ShowNotification("Vous avez débanni ~b~" .. data.current.label)

			TriggerServerEvent('AdminMenu:unban', data.current.value.identifier)

		  end,
		  function(data, menu)
			  menu.close()
		  end
	  )	
	end)
  
end

function OpenIDMenu()
  ESX.UI.Menu.CloseAll()
  local elements = {}
  
  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'id_card_menu',
	{
		title    = 'Mes Papiers',
		align = 'right',
		elements = {
			{label = 'Carte d\'identité', value = 'ID'},
			{label = 'Permis de conduire', value = 'VE'},
			{label = 'Permis d\'armes', value = 'AR'},
			{label = 'Visite médical (travail/ppa)', value = 'VM'},
			{label = 'Certificat médical (drogue)', value = 'CM'},
			{label = 'Porte Document', value = 'PD'},
		}
	},
	function(data, menu)
		
		if data.current.value == "ID" then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
			end
		end
		
		if data.current.value == "VE" then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
			end
		end
		
		if data.current.value == "AR" then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'ppa')
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'ppa')
			end
		end
		
		if data.current.value == "VM" then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'vmedic')
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'vmedic')
			end
		end
		
		if data.current.value == "CM" then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'cmedic')
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'cmedic')
			end
		end
		
		if data.current.value == "PD" then
			ESX.UI.Menu.CloseAll()
			Citizen.Wait(10)
			TriggerEvent('esx_documents:openMenu')
		
		end
		
	end,
	function(data, menu)
		menu.close()
	end
)
end

local vehZ = nil

function OpenMenuAutres()
	local elements = {}
	table.insert(elements, {label = 'Fouiller',	value = 'menuperso_thief'})
	table.insert(elements, {label = '[Debug] Monter dans le vehicule freeze',	value = 'menuperso_debugveh'})
	table.insert(elements, {label = '[Debug] Bug point 0, 0, 0 (dessous map)',	value = 'menuperso_debugpos'})
	table.insert(elements, {label = 'Enregister avec rockstar editor',	value = 'rockstareditrec'})
	table.insert(elements, {label = "Arreter l'enregistrement et ne pas save",	value = 'rockstareditsaveno'})
	table.insert(elements, {label = "Arreter l'enregistrement et save",	value = 'rockstareditsaveyes'})
	table.insert(elements, {label = "Ouvrir le Rockstar editor",	value = 'rockstareditor'})
	-- table.insert(elements, {label = 'Porter sur l\'épaule',	value = 'menuperso_carry'})
	-- table.insert(elements, {label = 'Porter dans les bras',	value = 'menuperso_lyftupp'})
	-- table.insert(elements, {label = 'Porter sur le dos',	value = 'menuperso_piggyback'})		
	table.insert(elements, {label = 'Prendre en otage',	value = 'menuperso_takehostage'})	
	-- table.insert(elements, {label = 'Mettre une claque',	value = 'menuperso_claque'})	
	table.insert(elements, {label = 'Info Services', value = 'menuperso_infotrafic'})
	-- table.insert(elements, {label = 'Afficher/Cacher HUD',	value = 'menuperso_showhud'})
	-- table.insert(elements, {label = 'Mode Cinema',	value = 'menuperso_cinema'})
	table.insert(elements, {label = 'Ecouter de la radio',	value = 'menuperso_mp3'})
	-- table.insert(elements, {label = 'Mode Editor',	value = 'menuperso_editor'})
					
	ESX.UI.Menu.Open(				
		'default', GetCurrentResourceName(), 'menuperso_autres',
		{
			title    = 'Autres',
			align = 'right',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'menuperso_editor' then
				TriggerEvent('OpenClipSaver')
			end

			if data.current.value == 'menuperso_infotrafic' then
				TriggerEvent('ToggleScoreBoard')
			end

			if data.current.value == 'menuperso_cinema' then
				func_showcine()
			end
				
			if data.current.value == 'menuperso_showhud' then
				func_showhud()
			end

			if data.current.value == 'menuperso_thief' then
				if IsPedArmed(PlayerPedId(), 7) then
					local player, distance = ESX.Game.GetClosestPlayer()
					if distance ~= -1 and distance <= 3.0 then
						TriggerServerEvent('core_inventory:custom:searchPlayer', data.current.value)
						TriggerServerEvent('esx_policejob:fouiller', GetPlayerServerId(player))
					else
						ESX.ShowNotification('aucun joueur à proximité')
					end
				else
					ESX.ShowNotification('vous n\avez pas d\'armes')
				end
			end
			
			if data.current.value == 'menuperso_takehostage' then
				TriggerEvent('takehostage')
			end
			
			if data.current.value == 'menuperso_debugveh' then
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
				local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
				local locked = GetVehicleDoorLockStatus(closecar)
				if locked == 1 then
				TaskWarpPedIntoVehicle(GetPlayerPed(-1),closecar,-1)
				ESX.ShowNotification('Rentre la voiture dans un garage et ressort la pour la debloquer aux autres')
				else
				ESX.ShowNotification('le vehicule est verouillé, deverouille le avant de monter')
				end
			end

			if data.current.value == 'menuperso_debugpos' then
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 0.0, 0.0, 0.0, true) <= 20.0 then
					SetEntityCoords(PlayerPedId(), 0.0, 0.0, 71.13)
					TriggerEvent('Core:ShowNotification', "~g~Vous avez été ramené sur Terre.")
				else
					TriggerEvent('Core:ShowNotification', "~r~Vous n'êtes pas au point 0.0, 0.0, 0.0. Faite un /report !")
				end
			end
		--Rockstar editor
			if data.current.value == 'rockstareditrec' then
				isRecording = true
				StartRecording(1)
			end
			if data.current.value == 'rockstareditsaveno' and isRecording then
					isRecording = false
					StopRecordingAndDiscardClip()
			elseif data.current.value == 'rockstareditsaveno' and not isRecording then
				ESX.ShowNotification("Il faut que tu sois en enregistrement.")
			end
			if data.current.value == 'rockstareditsaveyes' and isRecording then
					isRecording = false
					StopRecordingAndSaveClip()
			elseif data.current.value == 'rockstareditsaveyes' and not isRecording then
				ESX.ShowNotification("Il faut que tu sois en enregistrement.")
			end

			if data.current.value == 'rockstareditor' and not isRecording then
				ESX.ShowNotification("Va dans l'accueil de FiveM ou sur le Sandbox pour pouvoir edit tes clip!")
			elseif data.current.value == 'rockstareditor' and isRecording then
				ESX.ShowNotification("Mets fin a ton enregistrement avant.")
			end 
		--Rockstar editor	
			if data.current.value == 'menuperso_claque' then
				TriggerEvent('claque')
			end
				
			if data.current.value == 'menuperso_piggyback' then
				TriggerEvent('piggyback')
			end
				
			if data.current.value == 'menuperso_lyftupp' then
				TriggerEvent('lyftupp')
			end
			
			if data.current.value == 'menuperso_carry' then
				TriggerEvent('carrypeople')
			end
			
			if data.current.value == 'menuperso_mp3' then
					radioZ = true

					local elements = {}
					table.insert(elements, {label = 'Eteindre la radio', value = 'menuperso_radio_off'})
					table.insert(elements, {label = 'NEBULA RADIO', value = 'menuperso_radio_nebula'})
					table.insert(elements, {label = 'NRJ', value = 'menuperso_radio_nrj'})
					table.insert(elements, {label = 'Fun Radio', value = 'menuperso_radio_funradio'})
					table.insert(elements, {label = 'Skyrock', value = 'menuperso_radio_skyrock'})
					table.insert(elements, {label = 'Virgin Radio', value = 'menuperso_radio_virginradio'})
					
					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_radio',
						{
							title    = 'Radio Menu',
							align = 'right',
							elements = elements
						},
						function(data2, menu2)

							--[[if data2.current.value == 'menuperso_radio_off' then
								TriggerEvent('skinchanger:getSkin', function(skin)
									if skin.sex == 0 then
										local clothesSkin = {
											['helmet_1'] = 0, ['helmet_2'] = 0
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									else
										local clothesSkin = {
											['helmet_1'] = 0, ['helmet_2'] = 0
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									end
								end)
							else
								local rand = math.random(0,7)
								TriggerEvent('skinchanger:getSkin', function(skin)
									if skin.sex == 0 then
										local clothesSkin = {
											['helmet_1'] = 15, ['helmet_2'] = rand
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									else
										local clothesSkin = {
											['helmet_1'] = 15, ['helmet_2'] = rand
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									end
								end)
							end]]
						
							
							if data2.current.value == 'menuperso_radio_off' then
								TriggerEvent('radio:start', "")
							elseif data2.current.value == 'menuperso_radio_nebula' then
								TriggerEvent('radio:start', "https://listen.radioking.com/radio/373141/stream/423298")
							elseif data2.current.value == 'menuperso_radio_nrj' then
								TriggerEvent('radio:start', "http://185.52.127.155/fr/30001/mp3_128.mp3")
							elseif data2.current.value == 'menuperso_radio_funradio' then
								TriggerEvent('radio:start', "http://icecast.funradio.fr/fun-1-44-128.mp3")
							elseif data2.current.value == 'menuperso_radio_skyrock' then
								TriggerEvent('radio:start', "http://icecast.skyrock.net/s/natio_mp3_128k.mp3")
							elseif data2.current.value == 'menuperso_radio_virginradio' then
								TriggerEvent('radio:start', "http://vr-live-mp3-64.scdn.arkena.com/virginradio.mp3")
							end
							
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

function OpenMenuVetements()
  local elements = {}
					
					table.insert(elements, {label = 'Remettre Vetements',							value = 'restore_cloth'})
					
					table.insert(elements, {label = 'Retirer Casque/Chapeau',							value = 'remove_heat'})
					table.insert(elements, {label = 'Retirer Tshirt/Veste',    							value = 'remove_toso'})
					table.insert(elements, {label = 'Retirer Pantalon',							value = 'remove_pant'})
					table.insert(elements, {label = 'Retirer Chaussures',							value = 'remove_shoes'})
					
					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_remove_cloth',
						{
							title    = 'Vetements',
							align = 'right',
							elements = elements
						},
						function(data, menu)

							local playerPed = GetPlayerPed(-1)
							TriggerEvent('skinchanger:getSkin', function(skin)
							
								if data.current.value == 'restore_cloth' then

									ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
										TriggerEvent('skinchanger:loadSkin', skin)
									end)
								end
							
								if data.current.value == 'remove_heat' then
									if skin.sex == 0 then
										local clothesSkin = {
										['mask_1'] = 0, ['mask_1'] = 0,
										['ears_1'] = -1, ['ears_2'] = 0,
										['glasses_1'] = 0, ['glasses_2'] = 0,
										['helmet_1'] = -1, ['helmet_2'] = 0
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									else
										local clothesSkin = {
										['mask_1'] = 0, ['mask_1'] = 0,
										['ears_1'] = -1, ['ears_2'] = 0,
										['glasses_1'] = 5, ['glasses_2'] = 0,
										['helmet_1'] = -1, ['helmet_2'] = 0
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									end
								end

								if data.current.value == 'remove_toso' then
									if skin.sex == 0 then
										local clothesSkin = {
											['tshirt_1'] = 15, ['tshirt_2'] = 0,
											['torso_1'] = 15, ['torso_2'] = 0,
											['chain_1'] = 0, ['chain_0'] = 0,
											['arms'] = 15, ['arms_2'] = 0
											}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									else
										local clothesSkin = {
											['tshirt_1'] = 14, ['tshirt_2'] = 0,
											['torso_1'] = 15, ['torso_2'] = 1,
											['chain_1'] = 0, ['chain_0'] = 0,
											['arms'] = 15, ['arms_2'] = 0
											}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									end
								end

								if data.current.value == 'remove_pant' then
									if skin.sex == 0 then
										local clothesSkin = {
										['pants_1'] = 61, ['pants_2'] = 1
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									else
										local clothesSkin = {
										['pants_1'] = 15, ['pants_2'] = 3
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									end
								end

								if data.current.value == 'remove_shoes' then
									if skin.sex == 0 then
										local clothesSkin = {
										['shoes_1'] = 34, ['shoes_2'] = 0
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									else
										local clothesSkin = {
										['shoes_1'] = 35, ['shoes_2'] = 0
										}
										TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
									end
								end
							end)
							
						end,
						function(data, menu)
							menu.close()
							ESX.UI.Menu.CloseAll()
						end
					)

end

function admin_OpenGetWeaponMenu()

  ESX.TriggerServerCallback('admin:getVaultWeapons', function(weapons)

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
      'default', GetCurrentResourceName(), 'admin_OpenGetWeaponMenu',
      {
        title    = 'Retirer Arme',
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('admin:removeVaultWeapon', function()
		  admin_OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function admin_OpenPutWeaponMenu()

  local elements   = {}

  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed, weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'admin_OpenPutWeaponMenu',
    {
      title    = 'Déposer Arme',
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('admin:addVaultWeapon', function()
		admin_OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function helpeur_OpenGetWeaponMenu()

	ESX.TriggerServerCallback('helpeur:getVaultWeapons', function(weapons)
  
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
		'default', GetCurrentResourceName(), 'helpeur_OpenGetWeaponMenu',
		{
		  title    = 'Retirer Arme',
		  align = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
  
		  ESX.TriggerServerCallback('helpeur:removeVaultWeapon', function()
			helpeur_OpenGetWeaponMenu()
		  end, data.current.value)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
function helpeur_OpenPutWeaponMenu()
  
	local elements   = {}
  
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do
  
	  local weaponHash = GetHashKey(weaponList[i].name)
  
	  if HasPedGotWeapon(playerPed, weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
	  end
  
	end
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'helpeur_OpenPutWeaponMenu',
	  {
		title    = 'Déposer Arme',
		align = 'right',
		elements = elements,
	  },
	  function(data, menu)
  
		menu.close()
  
		ESX.TriggerServerCallback('helpeur:addVaultWeapon', function()
			helpeur_OpenPutWeaponMenu()
		end, data.current.value)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
end

function OpenPersonnelMenu()
	
	ESX.UI.Menu.CloseAll()
	
	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group
		
		local elements = {}
		
		--if cToggle == true then
			--TriggerEvent('watermark:Enable')
			--cToggle = false
		--end
		
		if (IsInVehicle()) then 
			local vehicle = GetVehiclePedIsIn( playerPed, false )
			if ( GetPedInVehicleSeat( vehicle, -1 ) == GetPlayerPed(-1) ) then
				table.insert(elements, {label = 'Véhicule', value = 'menuperso_vehicule'})
			end
		end

		table.insert(elements, {label = 'Téléphone', value = 'menuperso_phone'})
		table.insert(elements, {label = 'Mes Factures', value = 'menuperso_factures'})
		table.insert(elements, {label = 'Menu Animations', value = 'menuperso_animations'})
		table.insert(elements, {label = 'Menu Animals', value = 'menuperso_animal'})
		table.insert(elements, {label = 'Autres', value = 'menuperso_autres'})
		if playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' then
			-- table.insert(elements, {label = 'Coffre Weapon Admin', value = 'menuperso_modo_vault'})
			table.insert(elements, {label = "Mettre/Enlever de la modération", value = 'menuperso_setmodo'})
		end

		if playergroup == 'mod' then
			-- table.insert(elements, {label = 'Coffre Weapon Helpeur', value = 'menuperso_helpeur_vault'})
			table.insert(elements, {label = "Mettre/Enlever le mode Helpeur", value = 'menuperso_sethelpeur'})
		end
				
		if CanAccessModeration() and (playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner') then
			table.insert(elements, {label = 'Modération', value = 'menuperso_modo'})
		end

		if CanAccessModeration() and playergroup == 'mod' then
			table.insert(elements, {label = 'Helpeurs', value = 'menuperso_helpeur'})
		end
		
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'menu_perso',
			{
				--title    = 'Menu Personnel [' .. PlayerData.job.label .. ' - ' .. PlayerData.job.grade_label .. ']',
				title    = 'Menu Personnel',
				align = 'right',
				elements = elements
			},
			function(data, menu)

				if data.current.value == 'menuperso_vet' then
					local elements = {}
					
					table.insert(elements, {label = 'Mes Accessoires',		value = 'menuperso_accessoires'})
					table.insert(elements, {label = 'Mes Vetements',		value = 'menuperso_vetements'})
						
					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_vet',
						{
							title    = 'Vetements & Accessoires',
							align = 'right',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_accessoires' then
								TriggerEvent('esx_accessories:OpenAcc')
							elseif data2.current.value == 'menuperso_vetements' then
								OpenMenuVetements()
							end
							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
					
				end

				if data.current.value == 'menuperso_vehicle' then
					local elements = {}
					
					table.insert(elements, {label = 'Lock/Unlock Véhicule',			value = 'menuperso_vehiclelock'})
					table.insert(elements, {label = 'Inventaire Véhicule',			value = 'menuperso_vehinv'})
						
					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_vehicle',
						{
							title    = 'Vehicule Menu',
							align = 'right',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_vehiclelock' then
								TriggerEvent('vehiclelock:Lock')
							elseif data2.current.value == 'menuperso_vehinv' then
								TriggerEvent('esx_truck_inventory:Open')
							end
							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
					
				end

				if data.current.value == 'menuperso_setmodo' then

					if not isInModeration then
						local playerPedValid = exports['Nebula_Core']:GetPlayerPedValid()
						local elements = { }
						for index, value in ipairs(playerPedValid) do
							table.insert(elements, {label = value.name, value = value.model})
						end
	
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_setmodo',
							{
								title    = 'Choisissez votre ped de modération',
								align = 'right',
								elements = elements
							},
							function(pedData, pedMenu)
								ChangePed(pedData.current.value)
								print(PlayerPedId(), GetHashKey(pedData.current.value), pedData.current.value, IsPedModel(PlayerPedId(), GetHashKey(pedData.current.value)))
								if exports['Nebula_Core']:IsPlayerPedValid() then
									isInModeration = true
									TriggerServerEvent('CoreLog:SendDiscordLog', 'Pointage Modérateurs', GetPlayerName(PlayerId()) .. " a **pris** son service de modérateur.", 'Green')
									exports["Neb_radio"]:GivePlayerAccessToFrequency(1)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(2)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(3)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(4)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(5)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(6)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(7)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(8)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(9)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(10)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(11)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(12)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(13)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(14)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(15)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(16)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(17)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(18)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(19)
									exports["Neb_radio"]:GivePlayerAccessToFrequency(20)
									TriggerServerEvent('Core:SetCanHandleCommand', GetPlayerServerId(PlayerId()), true)
								end
								pedMenu.close()
								menu.close()
							end,
							function(pedData, pedMenu)
								DefaultPed()
								pedMenu.close()
							end,
							function(pedData, pedMenu)
								ChangePed(pedData.current.value)
							end,
							function(pedData, pedMenu)
								if not isInModeration then
									DefaultPed()
								end
							end
						)
					else
						TriggerEvent('esx_showname:Disable')
						TriggerServerEvent('CoreLog:SendDiscordLog', 'Pointage Modérateurs', GetPlayerName(PlayerId()) .. " a **arrêté** son service de modérateur.", 'Red')
						DefaultPed()
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(1)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(2)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(3)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(4)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(5)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(6)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(7)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(8)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(9)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(10)  
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(11)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(12)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(13)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(14)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(15)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(16)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(17)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(18)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(19)
						exports["Neb_radio"]:RemovePlayerAccessToFrequency(20)
						isInModeration = false
						TriggerServerEvent('Core:SetCanHandleCommand', GetPlayerServerId(PlayerId()), false)
						menu.close()
					end
				end

				if data.current.value == 'menuperso_sethelpeur' then
					if IsPedModel(PlayerPedId(), GetHashKey("ig_ary_02")) then
						TriggerEvent('esx_showname:Disable')
						TriggerServerEvent('CoreLog:SendDiscordLog', 'Pointage Helpeurs', GetPlayerName(PlayerId()) .. " a **arrêté** son service de Helpeur.", 'Red')
						TriggerServerEvent('Core:SetCanHandleCommand', GetPlayerServerId(PlayerId()), false)
						TriggerEvent('Core:ShowNotification', "Mode Helpeur en cours de ~r~désactivation~w~...")
						DefaultPed()
						Citizen.Wait(1000)
						TriggerEvent('Core:ShowAdvancedNotification', "~b~Helpeur", "~y~Notification", "Tu es désormais ~g~visible~w~ et un joueur lambda !", 'CHAR_SOCIAL_CLUB', 1, false, false, 180)
						SetEntityVisible(playerPed, true, false)
					else
						TriggerServerEvent('Core:SetCanHandleCommand', GetPlayerServerId(PlayerId()), true)
						TriggerServerEvent('CoreLog:SendDiscordLog', 'Pointage Helpeurs', GetPlayerName(PlayerId()) .. " a **pris** son service de Helpeur.", 'Green')
						TriggerEvent('Core:ShowNotification', "Mode Helpeur en cours ~g~d'activation~w~...", true, true) 
						ChangePed("ig_ary_02")
						Citizen.Wait(1000)
						TriggerEvent('Core:ShowAdvancedNotification', "~b~Helpeur", "~y~Notification", "Tu es désormais en mode ~y~Helpeur~w~ et ~r~invisible~w~. Le responsable Helpeur t'a à l'oeil !", 'CHAR_SOCIAL_CLUB', 1, false, false, 200)
						SetEntityVisible(playerPed, false, false)
					end
				end

				if data.current.value == 'menuperso_modo_vault' then
					local elements = {}
					table.insert(elements, {label = 'Déposer Arme', value = 'modo_vault_put'})
					table.insert(elements, {label = 'Retirer Arme', value = 'modo_vault_get'})
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'modo_vault',
						{
							title    = 'Coffre Admin (Weapon)',
							align = 'right',
							elements = elements
						},
						function(data3, menu3)
							if data3.current.value == 'modo_vault_put' then
								admin_OpenPutWeaponMenu()
							elseif data3.current.value == 'modo_vault_get' then
								admin_OpenGetWeaponMenu()
							end
						end,
						function(data3, menu3)
							menu3.close()
						end
					)
				end

				if data.current.value == 'menuperso_helpeur_vault' then
					local elements = {}
					table.insert(elements, {label = 'Déposer Arme', value = 'modo_vault_put'})
					table.insert(elements, {label = 'Retirer Arme', value = 'modo_vault_get'})
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'modo_vault',
						{
							title    = 'Coffre Helpeur (Weapon)',
							align = 'right',
							elements = elements
						},
						function(data3, menu3)
							if data3.current.value == 'modo_vault_put' then
								helpeur_OpenPutWeaponMenu()
							elseif data3.current.value == 'modo_vault_get' then
								helpeur_OpenGetWeaponMenu()
							end
						end,
						function(data3, menu3)
							menu3.close()
						end
					)
				end

				if data.current.value == 'menuperso_helpeur' then
					local elements = {}
					table.insert(elements, {label = 'Téléportation',    							value = 'menuperso_helpeurs_tp'})
					table.insert(elements, {label = 'Mode Invisible (sens unique)',								value = 'menuperso_helpeur_mode_fantome'})
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'modo_vault',
						{
							title    = 'Helpeurs',
							align = 'right',
							elements = elements
						},
						function(data3, menu3)
							if data3.current.value == 'menuperso_helpeurs_tp' and CanAccessModeration() then
								local elements = {}
								table.insert(elements, {label = 'Se téléporté sur un joueur',    							value = 'menuperso_modo_tp_toplayer'})
								table.insert(elements, {label = 'Téléporté un joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
								table.insert(elements, {label = 'Se téléporté sur le marqueur',							value = 'menuperso_modo_tp_marcker'})
											
								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_modo_tp',
									{
										title    = 'Téléportation',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_tp_toplayer' then
											OpenModMenu("TP2P")
										elseif data3.current.value == 'menuperso_modo_tp_playertome' then
											OpenModMenu("TP2M")
										elseif data3.current.value == 'menuperso_modo_tp_marcker' then
											admin_tp_marcker()
											TriggerServerEvent('bot:tp_marckerZ')
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							elseif data3.current.value == 'menuperso_helpeur_mode_fantome' then
								SetEntityVisible(playerPed, false, false)
								TriggerEvent('Core:ShowNotification', "Mode invisible ~g~activé~w~...", true, true) 
								TriggerServerEvent('bot:invisibleZ')
							end
						end,
						function(data3, menu3)
							menu3.close()
						end
					)
				end

				if data.current.value == 'menuperso_modo' then
					local elements = {}
				
					if playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' then
						table.insert(elements, {label = 'Afficher/Cacher noms des joueurs',	value = 'menuperso_modo_showname'})
						table.insert(elements, {label = 'Afficher/Cacher coordonnées', value = 'menuperso_modo_showcoord'})
						table.insert(elements, {label = 'Afficher/Cacher ScoreBoard Admin', value = 'menuperso_modo_scoreboard'})
						table.insert(elements, {label = 'Mode spectateur', value = 'menuperso_modo_spec_player'})
						table.insert(elements, {label = 'FDO - Appels de renforts', value = 'menuperso_modo_fdo_1032'})
						table.insert(elements, {label = 'Verifier Argents/Items', value = 'menuperso_modo_checkaccount'})
						--table.insert(elements, {label = 'Réanimer une personne', value = 'menuperso_modo_heal_player'})
						--table.insert(elements, {label = 'Donner une arme', value = 'menuperso_modo_weap'})
						table.insert(elements, {label = 'Retirer items, argent ou armes', value = 'menuperso_modo_removeitems'})
						table.insert(elements, {label = 'Arme', value = 'menuperso_modo_weapon'})
						table.insert(elements, {label = 'Donner quelque chose', value = 'menuperso_donner'})
						--table.insert(elements, {label = 'Donne un item', value = 'menuperso_modo_item'})
						--table.insert(elements, {label = 'Donner de l\'argent (cash)', value = 'menuperso_modo_give_money'})
						--table.insert(elements, {label = 'Donner de l\'argent (banque)', value = 'menuperso_modo_give_moneybank'})
						--table.insert(elements, {label = 'Donner de l\'argent (sale)', value = 'menuperso_modo_give_moneydirty'})
						table.insert(elements, {label = 'Téléportation', value = 'menuperso_modo_tp'})
						--table.insert(elements, {label = 'Se téléporté sur un joueur', value = 'menuperso_modo_tp_toplayer'})
						--table.insert(elements, {label = 'Téléporté un joueur sur moi', value = 'menuperso_modo_tp_playertome'})
						--table.insert(elements, {label = 'Se téléporté sur le marqueur', value = 'menuperso_modo_tp_marcker'})
						table.insert(elements, {label = 'Véhicule', value = 'menuperso_modo_vehicle'})
						--table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
						--table.insert(elements, {label = 'Supprimer véhicule',						value = 'menuperso_modo_delveh'})
						--table.insert(elements, {label = 'Spawn véhicule',							value = 'menuperso_modo_veh'})
						--table.insert(elements, {label = 'Retourner le véhicule',								value = 'menuperso_modo_vehicle_flip'})
						--table.insert(elements, {label = 'NoClip (voler)',										value = 'menuperso_modo_no_clip'})
						table.insert(elements, {label = 'Ped',									value = 'menuperso_modo_ped'})
						
						--table.insert(elements, {label = 'Changer le job',						value = 'menuperso_setjob'})
						--table.insert(elements, {label = 'Mode Invincible',									value = 'menuperso_modo_godmode'})
						--table.insert(elements, {label = 'Mode Invisible',								value = 'menuperso_modo_mode_fantome'})
						--table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
						--table.insert(elements, {label = 'Changer de ped',									value = 'menuperso_modo_changer_ped'})
						--table.insert(elements, {label = 'Changer de ped (Add-On)',									value = 'menuperso_modo_changer_pedaddon'})
						table.insert(elements, {label = 'Kick/Ban',						value = 'menuperso_modo_kick_ban'})
						table.insert(elements, {label = 'Aller à la salle de modération',                        value = 'sallemoderation'})
						--table.insert(elements, {label = 'Kick une personne',						value = 'menuperso_modo_kick_player'})
						--table.insert(elements, {label = 'Bannir une personne',						value = 'menuperso_modo_ban_player'})
						--table.insert(elements, {label = 'Reset une personne',						value = 'menuperso_modo_reset_player'})
						--table.insert(elements, {label = 'Whitelist une personne',						value = 'menuperso_modo_wl'})
						--table.insert(elements, {label = 'Mettre une personne VIP',						value = 'menuperso_modo_vip'})
						--table.insert(elements, {label = 'Actualiser la WhiteList et Banni',						value = 'menuperso_modo_load_bans'})
						--table.insert(elements, {label = 'Débannir une personne',						value = 'menuperso_modo_getbanned'})
						--table.insert(elements, {label = 'Activer la WhiteList',						value = 'menuperso_modo_eWL'})
					end
					--TriggerEvent('watermark:Disable')
					--cToggle = true
				
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_modo',
						{
							title    = 'Modération',
							align = 'right',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_modo_removeitems' and CanAccessModeration() then
								OpenModMenu("Ritems")
							end

							if data2.current.value == 'menuperso_modo_weapon' and CanAccessModeration() then
								local elements = {}
								table.insert(elements, {label = 'Donner une arme',								value = 'menuperso_modo_weap'})
								table.insert(elements, {label = 'Retirer les armes',						value = 'menuperso_modo_removeweap'})

								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_modo_weapon',
									{
										title    = 'Armes',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_weap' then
											OpenModMenu("Weapon")
										elseif data3.current.value == 'menuperso_modo_removeweap' then
											OpenModMenu("RWeap")
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'sallemoderation' and CanAccessModeration() then
								local ply = playerPed
								SetEntityCoords(ply, 413.13, -998.46, -99.40-0.98, false, false, false)
							end
								
							

							if data2.current.value == 'menuperso_modo_ped' then
								local elements = {}
								table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
								table.insert(elements, {label = 'Changer de ped',									value = 'menuperso_modo_changer_ped'})
								table.insert(elements, {label = 'Changer de ped (Add-On)',									value = 'menuperso_modo_changer_pedaddon'})
								table.insert(elements, {label = 'Changer le job',						value = 'menuperso_setjob'})
								table.insert(elements, {label = 'Mode Invincible',									value = 'menuperso_modo_godmode'})
								table.insert(elements, {label = 'Mode Invisible',								value = 'menuperso_modo_mode_fantome'})
								table.insert(elements, {label = 'Reset une personne',						value = 'menuperso_modo_reset_player'})

								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_modo_ped',
									{
										title    = 'Ped',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_changer_skin' then
											OpenModMenu("SKIN")
										elseif data3.current.value == 'menuperso_modo_changer_ped' then
											OpenPedMenu()
										elseif data3.current.value == 'menuperso_modo_changer_pedaddon' then
											OpenPedAddOnMenu()
										elseif data3.current.value == 'menuperso_modo_godmode' then
											admin_godmode()
											TriggerServerEvent('bot:godmodeZ')
										elseif data3.current.value == 'menuperso_modo_mode_fantome' then
											admin_mode_fantome()
											TriggerServerEvent('bot:invisibleZ')
										elseif data3.current.value == 'menuperso_modo_reset_player' then
											OpenModMenu("Reset")
										elseif data3.current.value == 'menuperso_setjob' then
											OpenModMenu("Set Job")
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_modo_vehicle' and CanAccessModeration() then
								local elements = {}
								table.insert(elements, {label = 'Réparer véhicule (exceptionnel!)', value = 'menuperso_modo_vehicle_repair'})
								table.insert(elements, {label = 'Dévérouiller véhicule', value = 'menuperso_modo_unlockveh'})
								table.insert(elements, {label = 'Supprimer véhicule', value = 'menuperso_modo_delveh'})
								table.insert(elements, {label = 'Spawn véhicule', value = 'menuperso_modo_veh'})
								table.insert(elements, {label = 'Retourner le véhicule', value = 'menuperso_modo_vehicle_flip'})

								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_modo_vehicle',
									{
										title    = 'Véhicule',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_vehicle_repair' then
											local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(playerPed, 0)))
											admin_vehicle_repair()
											TriggerServerEvent('CoreLog:SendDiscordLog', 'Réparation de véhicule', "**"..GetPlayerName(PlayerId()) .. "** a réparé un véhicule. **`[".. model .. "]`**", 'Green')
										elseif data3.current.value == 'menuperso_modo_delveh' then
											local ply = playerPed --GetPlayerPed(-1)
											local cor = coords--GetEntityCoords(ply)
											
											if vehZ ~= nil then
												ESX.Game.DeleteVehicle(vehZ)
											end
											
											if IsPedInAnyVehicle(ply) then
												vehZ = GetVehiclePedIsIn(ply)
												ESX.Game.DeleteVehicle(vehZ)
											else
												vehZ = GetClosestVehicle(cor.x, cor.y, cor.z, 7.0, 0, 70)
												ESX.Game.DeleteVehicle(vehZ)
											end
										elseif data3.current.value == 'menuperso_modo_unlockveh' then
											local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
											if vehicle == 0 then
												vehicle = IsPedInAnyVehicle(playerPed)
											end
											SetVehicleDoorsLockedForAllPlayers(vehicle, false)
											SetVehicleDoorsLocked(vehicle, 1)
											local plate = GetVehicleNumberPlateText(vehicle)
											ESX.ShowNotification("Le véhicule ".. plate .. " a été dévérouillé");
										elseif data3.current.value == 'menuperso_modo_veh' then
											TriggerEvent('esx_vehicleshop:OpenVehMenu')
										elseif data3.current.value == 'menuperso_modo_vehicle_flip' then
											admin_vehicle_flip()
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_modo_kick_ban' and CanAccessModeration() then
								local elements = {}
								table.insert(elements, {label = 'Kick une personne', value = 'menuperso_modo_kick_player'})
								-- table.insert(elements, {label = 'Bannir une personne', value = 'menuperso_modo_ban_player'})
								-- table.insert(elements, {label = 'Actualiser la liste des whitelist et Banni', value = 'menuperso_modo_load_bans'})
								-- table.insert(elements, {label = 'Débannir une personne', value = 'menuperso_modo_getbanned'})
								-- table.insert(elements, {label = 'Supprimer une personne de la whitelist', value = 'menuperso_modo_unwhitelist'})
								-- table.insert(elements, {label = 'Ajouter une personne de la whitelist', value = 'menuperso_modo_addwhitelist'})

								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_modo_kick_ban',
									{
										title    = 'Kick/Ban',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_kick_player' then
											OpenModMenu("Kick")
										elseif data3.current.value == 'menuperso_modo_ban_player' then
											OpenModMenu("Ban")
										elseif data3.current.value == 'menuperso_modo_load_bans' then
											ESX.ShowNotification("la liste des whitelisted et banni a été actualisé!")
											--TriggerServerEvent('whitelist:reloadwhitelist')
											TriggerServerEvent('AdminMenu:refresh')
										elseif data3.current.value == 'menuperso_modo_getbanned' then
											OpenBannedList()
										elseif data3.current.value == 'menuperso_modo_unwhitelist' then
											OpenModMenu("unwhitelist")
										elseif data3.current.value == 'menuperso_modo_addwhitelist' then
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'whitelist',
												{
													title = "Personne à whitelist"
												}, 	
												function(data2, menu2)

												local raison = data2.value

												if raison == nil then
													ESX.ShowNotification("Merci de mettre un steamHex")
												else
													menu2.close()
													TriggerServerEvent('whitelist:addwhitelist', raison)
												end

												end, function(data2, menu2)
												menu2.close()
											end)
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_modo_tp' and CanAccessModeration() then
								local elements = {}
								table.insert(elements, {label = 'Se téléporté sur un joueur', value = 'menuperso_modo_tp_toplayer'})
								table.insert(elements, {label = 'Téléporté un joueur sur moi', value = 'menuperso_modo_tp_playertome'})
								table.insert(elements, {label = 'Se téléporté sur le marqueur', value = 'menuperso_modo_tp_marcker'})
											
								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_modo_tp',
									{
										title    = 'Téléportation',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_tp_toplayer' then
											OpenModMenu("TP2P")
										elseif data3.current.value == 'menuperso_modo_tp_playertome' then
											OpenModMenu("TP2M")
										elseif data3.current.value == 'menuperso_modo_tp_marcker' then
											admin_tp_marcker()
											TriggerServerEvent('bot:tp_marckerZ')
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_donner' and CanAccessModeration() then
								local elements = {}
								table.insert(elements, {label = 'Donner une arme',	value = 'menuperso_modo_weap'})
								table.insert(elements, {label = 'Donne un item',	value = 'menuperso_modo_item'})
								table.insert(elements, {label = 'Donner de l\'argent (cash)',	value = 'menuperso_modo_give_money'})
								table.insert(elements, {label = 'Donner de l\'argent (banque)',	value = 'menuperso_modo_give_moneybank'})
								table.insert(elements, {label = 'Donner de l\'argent (sale)',	value = 'menuperso_modo_give_moneydirty'})
									
								ESX.UI.Menu.Open(
									
									'default', GetCurrentResourceName(), 'menuperso_donner',
									{
										title    = 'Donner quelque chose',
										align = 'right',
										elements = elements
									},
									function(data3, menu3)
				
										
										if data3.current.value == 'menuperso_modo_weap' then
											OpenModMenu("Weapon")
										elseif data3.current.value == 'menuperso_modo_item' then
											OpenModMenu("Item")
										elseif data3.current.value == 'menuperso_modo_give_money' then
											OpenModMenu("Money Cash")
										elseif data3.current.value == 'menuperso_modo_give_moneybank' then
											OpenModMenu("Money Bank")
										elseif data3.current.value == 'menuperso_modo_give_moneydirty' then
											OpenModMenu("Money Dirty")
										end
										
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							--if data2.current.value == 'menuperso_modo_getbanned' then
								--OpenBannedList()
							--end
							
							--if data2.current.value == 'menuperso_modo_delveh' then
								--local ply = playerPed --GetPlayerPed(-1)
								--local cor = coords--GetEntityCoords(ply)
								
								--if vehZ ~= nil then
									--ESX.Game.DeleteVehicle(vehZ)
								--end
								
								--if IsPedInAnyVehicle(ply) then
									--vehZ = GetVehiclePedIsIn(ply)
									--ESX.Game.DeleteVehicle(vehZ)
								--else
									--vehZ = GetClosestVehicle(cor.x, cor.y, cor.z, 7.0, 0, 70)
									--ESX.Game.DeleteVehicle(vehZ)
								--end
							--end
							
							--if data2.current.value == 'menuperso_modo_eWL' then
								--admin_WhiteList()
							--end
							
							--if data2.current.value == 'menuperso_modo_vip' then
								--OpenModMenu("vip")
							--end
							
							--if data2.current.value == 'menuperso_modo_wl' then
								--OpenModMenu("wl")
							--end
							
							--if data2.current.value == 'menuperso_modo_reset_player' then
								--OpenModMenu("Reset")
							--end
							
							--if data2.current.value == 'menuperso_modo_ban_player' then
								--OpenModMenu("Ban")
							--end

							--if data2.current.value == 'menuperso_modo_load_bans' then
								--ESX.ShowNotification("la liste des whitelisted et banni a été actualisé!")
								--TriggerServerEvent('es_admin:loadBans')
								--TriggerServerEvent('AdminMenu:refresh')
							--end
							
							--if data2.current.value == 'menuperso_modo_kick_player' then
								--OpenModMenu("Kick")
							--end
						
							--if data2.current.value == 'menuperso_modo_tp_toplayer' then
								--OpenModMenu("TP2P")
							--end
							
							--if data2.current.value == 'menuperso_setjob' then
								--OpenModMenu("Set Job")
							--end

							--if data2.current.value == 'menuperso_modo_tp_playertome' then
								--OpenModMenu("TP2M")
							--end

							--if data2.current.value == 'menuperso_modo_tp_pos' then
								--admin_tp_pos()
								--TriggerServerEvent('bot:tp_marckerZ')
							--end

							--if data2.current.value == 'menuperso_modo_no_clip' then
								--admin_no_clip()
								--TriggerServerEvent('bot:noclipZ', 0)
							--end

							--if data2.current.value == 'menuperso_modo_godmode' then
								--admin_godmode()
								--TriggerServerEvent('bot:godmodeZ')
							--end

							--if data2.current.value == 'menuperso_modo_mode_fantome' then
								--admin_mode_fantome()
								--TriggerServerEvent('bot:invisibleZ')
							--end

							--if data2.current.value == 'menuperso_modo_vehicle_repair' then
								--admin_vehicle_repair()
								--TriggerServerEvent('bot:vehicle_repairZ')
							--end

							--if data2.current.value == 'menuperso_modo_vehicle_spawn' then
								--admin_vehicle_spawn()--ok
							--end

							--if data2.current.value == 'menuperso_modo_vehicle_flip' then
								--admin_vehicle_flip()
							--end

							--if data2.current.value == 'menuperso_modo_give_money' then
								--admin_give_money()--ok
								--OpenModMenu("Money Cash")
							--end

							--if data2.current.value == 'menuperso_modo_give_moneybank' then
								--admin_give_bank()--ok
								--OpenModMenu("Money Bank")
							--end

							--if data2.current.value == 'menuperso_modo_give_moneydirty' then
								--admin_give_dirty()--ok
								--OpenModMenu("Money Dirty")
							--end

							if data2.current.value == 'menuperso_modo_showcoord' and CanAccessModeration() then
								modo_showcoord()
							end

							if data2.current.value == 'menuperso_modo_scoreboard' and CanAccessModeration() then
								if activescoreboard then
									TriggerEvent('ToggleScoreBoard')
									activescoreboard = false
								else
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'scoreboard_admin',
										{
											title = "Job"
										}, 	
										function(data2, menu2)

										local raison = data2.value

										if raison == nil then
											activescoreboard = true
											menu2.close()
											TriggerEvent('ToggleScoreBoardAdmin', "players")
										else
											activescoreboard = true
											menu2.close()
											TriggerEvent('ToggleScoreBoardAdmin', raison)
										end

										end, function(data2, menu2)
										menu2.close()
									end)
								end
							end

							if data2.current.value == 'menuperso_modo_showname' and CanAccessModeration() then
								modo_showname()--ok
							end

							--if data2.current.value == 'menuperso_modo_tp_marcker' then
								--admin_tp_marcker()
								--TriggerServerEvent('bot:tp_marckerZ')
							--end

							if data2.current.value == 'menuperso_modo_spec_player' and CanAccessModeration() then
								--admin_spec_player()--ok
								OpenSpectateMenu()
							end

							if data2.current.value == 'menuperso_modo_fdo_1032' and CanAccessModeration() then
								ESX.UI.Menu.CloseAll()
								TriggerEvent('Nebula_jobs:openBackupMenu', true)
							end

							--if data2.current.value == 'menuperso_modo_changer_skin' then
								--OpenModMenu("SKIN")
							--end

							--if data2.current.value == 'menuperso_modo_changer_ped' then
								--OpenPedMenu()
							--end

							--if data2.current.value == 'menuperso_modo_changer_pedaddon' then
								--OpenPedAddOnMenu()
							--end
							
							--if data2.current.value == 'menuperso_modo_veh' then
								--TriggerEvent('esx_vehicleshop:OpenVehMenu')
							--end
							
							--if data2.current.value == 'menuperso_modo_weap' then
								--OpenModMenu("Weapon")
							--end
							
							--if data2.current.value == 'menuperso_modo_removeweap' then
								--OpenModMenu("RWeap")
							--end
							
							--if data2.current.value == 'menuperso_modo_item' then
								--OpenModMenu("Item")
							--end
							
							if data2.current.value == 'menuperso_modo_checkaccount' and CanAccessModeration() then
								OpenModMenu("Player")
							end

						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end
				
				if data.current.value == 'menuperso_vehicule' then
					OpenVehiculeMenu()
					--TriggerEvent('watermark:Disable')
					--cToggle = true
				end

				if data.current.value == 'menuperso_voice' then
					--TriggerEvent('watermark:Disable')
					--cToggle = true
	
					local elements = {}
					
					table.insert(elements, {label = 'Chuchoter', value = 'menuperso_voice_chuchoter'})
					table.insert(elements, {label = 'Normal', value = 'menuperso_voice_normal'})
					table.insert(elements, {label = 'Crier', value = 'menuperso_voice_cier'})
					table.insert(elements, {label = 'Crier Fort', value = 'menuperso_voice_cierfort'})
						
					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_voice',
						{
							title    = 'Voice Menu',
							align = 'right',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_voice_chuchoter' then
								TriggerEvent('voice:chuchoter')
							end

							if data2.current.value == 'menuperso_voice_normal' then
								TriggerEvent('voice:normal')
							end

							if data2.current.value == 'menuperso_voice_cier' then
								TriggerEvent('voice:cier')
							end

							if data2.current.value == 'menuperso_voice_cierfort' then
								TriggerEvent('voice:cierfort')
							end
							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
					
				end
				
				if data.current.value == 'menuperso_identitycard' then
					OpenIDMenu()
				end

				if data.current.value == 'menuperso_phone' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_prefecture:OpenSim')
				end
				
				if data.current.value == 'menuperso_taxi' then
					ESX.TriggerServerCallback('fs_taxi:checkTaxi', function(can)
						if can then
							TriggerEvent('fs_taxi:rCall')
						else
							ESX.ShowNotification("Utilisez votre téléphone pour appeler un Taxi.")
						end
					end)
				end

				if data.current.value == 'menuperso_animal' then
					TriggerEvent('esx_eden_animal:OpenMenu')
					--TriggerEvent('watermark:Disable')
					--cToggle = true
				end
				
				if data.current.value == 'menuperso_inventaire' then
					ESX.ShowInventory()
				end
				
				if data.current.value == 'menuperso_inventaireHUD' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_inventoryhud:open')
				end
				
				if data.current.value == 'menuperso_animations' then
					TriggerEvent('esx_animations:OpenAnim')
					--TriggerEvent('watermark:Disable')
					--cToggle = true
				end
				
				if data.current.value == 'menuperso_autres' then
					OpenMenuAutres()
				end

				if data.current.value == 'menuperso_licences' then
					TriggerEvent('esx_policejob:MyLicence')
				end

				if data.current.value == 'menuperso_factures' then
					TriggerEvent('esx_billing:OpenFactures')
				end
				
				if data.current.value == 'menuperso_grade' then

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_grade',
						{
							title    = 'Gestion d\'entreprise #1',
							align = 'right',
							elements = {
								{label = 'Recruter',     value = 'menuperso_grade_recruter'},
								{label = 'Virer',              value = 'menuperso_grade_virer'},
								{label = 'Promouvoir', value = 'menuperso_grade_promouvoir'},
								{label = 'Destituer',  value = 'menuperso_grade_destituer'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_grade_recruter' then
								if PlayerData.job.grade_name == 'boss' then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:recruterplayer', GetPlayerServerId(closestPlayer), job,grade)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_virer' then
								if PlayerData.job.grade_name == 'boss' then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:virerplayer', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_promouvoir' then

								if PlayerData.job.grade_name == 'boss' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:promouvoirplayer', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							if data2.current.value == 'menuperso_grade_destituer' then

								if PlayerData.job.grade_name == 'boss' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:destituerplayer', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end	

				if data.current.value == 'menuperso_grade2' then

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_grade2',
						{
							title    = 'Gestion d\'entreprise #2',
							align = 'right',
							elements = {
								{label = 'Recruter',     value = 'menuperso_grade_recruter2'},
								{label = 'Virer',              value = 'menuperso_grade_virer2'},
								{label = 'Promouvoir', value = 'menuperso_grade_promouvoir2'},
								{label = 'Destituer',  value = 'menuperso_grade_destituer2'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_grade_recruter2' then
								if PlayerData.job2.grade_name == 'boss' then
										local job =  PlayerData.job2.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:recruterplayer2', GetPlayerServerId(closestPlayer), job,grade)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_virer2' then
								if PlayerData.job2.grade_name == 'boss' then
										local job =  PlayerData.job2.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:virerplayer2', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_promouvoir2' then

								if PlayerData.job2.grade_name == 'boss' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:promouvoirplayer2', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							if data2.current.value == 'menuperso_grade_destituer2' then

								if PlayerData.job2.grade_name == 'boss' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:destituerplayer2', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end	
			end,
			function(data, menu)				
				menu.close()
				--TriggerEvent('watermark:Disable')
				--cToggle = true
			end
		)
		
	end)
end
---------------------------------------------------------------------------Vehicule Menu
function OpenVehiculeMenu()
	local vehicle = GetVehiclePedIsIn(playerPed, false)	
	local engineRunning = GetIsVehicleEngineRunning(vehicle)
	local neonLightInstalled = IsVehicleNeonLightEnabled(vehicle)
	local neonOn = IsVehicleNeonLightEnabled(vehicle, 3)

	ESX.UI.Menu.CloseAll()
		
	local elements = {}

	-- table.insert(elements, {label = 'Fenetres',	value = 'menuperso_fenetres'})
	
	-- table.insert(elements, {label = 'Ceinture Sécurité',	value = 'menuperso_seatbelt'})

	-- table.insert(elements, {label = 'Changer de place',		value = 'menuperso_shuff'})

	if engineRunning then
		table.insert(elements, {label = 'Couper le moteur', value = 'menuperso_vehicule_MoteurOff'})
	else
		table.insert(elements, {label = 'Démarrer le moteur', value = 'menuperso_vehicule_MoteurOn'})
	end

	table.insert(elements, {label = 'Customisation', value = 'menuperso_custom'})
	
	--table.insert(elements, {label = 'Xenon Lights', value = 'menuperso_xenonlights'})
	
	--table.insert(elements, {label = 'Néon Lights', value = 'menuperso_neonlights'})
	
	-- table.insert(elements, {label = 'Activer/Désactiver Limitateur',	value = 'menuperso_lockspeed'})
	
	table.insert(elements, {label = 'Radio Menu',		value = 'menuperso_radio'})

	-- table.insert(elements, {label = 'Portes du véhicule',		value = 'menuperso_porte'})

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menuperso_vehicule',
		{
			--title    = 'menu_vehicule',
			title    = 'Véhicule',
			align = 'right',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'menuperso_custom' then
				local elements = {}
				table.insert(elements, {label = 'Xenon Lights', value = 'menuperso_xenonlights'})
				if neonLightInstalled then
					table.insert(elements, {label = 'Néon Lights', value = 'menuperso_neonlights'})
					if neonOn then
						table.insert(elements, {label = 'Éteindre néon', value = 'NeonOff'})
					else
						table.insert(elements, {label = 'Allumer néon', value = 'NeonOn'})
					end
				end
				
				ESX.UI.Menu.Open(
					
					'default', GetCurrentResourceName(), 'menuperso_custom',
					{
						title    = 'Customisation',
						align = 'right',
						elements = elements
					},
					function(data2, menu2)

						
						if data2.current.value == 'menuperso_xenonlights' then
							OpenXenonLights()
						elseif data2.current.value == 'menuperso_neonlights' then
							OpenNeonLights()
						elseif data2.current.value == 'NeonOff' then
							DisableVehicleNeonLights(vehicle,true)
							SetVehicleNeonLightEnabled(vehicle, 3, false)
							OpenVehiculeMenu()
						elseif data2.current.value == 'NeonOn' then
							DisableVehicleNeonLights(vehicle, false)
							SetVehicleNeonLightEnabled(vehicle, 3, true)
							OpenVehiculeMenu()
						end
						
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end

			if data.current.value == 'menuperso_fenetres' then
				local vehuse = GetVehiclePedIsIn( GetPlayerPed(-1), false )
				local elements2 = {
					{label = "Fermé", value = 'menuperso_fenetres_close' },
					{label = "Ouvrir", value = 'menuperso_fenetres_open' }
				}

				ESX.UI.Menu.Open(
					
					'default', GetCurrentResourceName(), 'menuperso_fenetres2',
					{
						title    = 'Ouvrir/Fermer la fenetre',
						align = 'right',
						elements = elements2
					},
					function(data3, menu3)
						local elements = {}
						table.insert(elements, {label = 'Toutes', value = 'menuperso_fenetres_all'})
						table.insert(elements, {label = 'Conducteur', value = 'menuperso_fenetres_conduc'})
						table.insert(elements, {label = 'Passager', value = 'menuperso_fenetres_passa'})
						table.insert(elements, {label = 'Arrière Gauche', value = 'menuperso_fenetres_gauch'})
						table.insert(elements, {label = 'Arrière Droite', value = 'menuperso_fenetres_droit'})

						if data3.current.value == 'menuperso_fenetres_close' then
							ESX.UI.Menu.Open(
								
								'default', GetCurrentResourceName(), 'menuperso_fenetres',
								{
									title    = 'Ouvrir/Fermer la fenetre',
									align = 'right',
									elements = elements
								},
								function(data2, menu2)

									if data2.current.value == 'menuperso_fenetres_all' then
										RollUpWindow(vehuse, 0)
										RollUpWindow(vehuse, 1)
										RollUpWindow(vehuse, 2)
										RollUpWindow(vehuse, 3)
									elseif data2.current.value == 'menuperso_fenetres_conduc' then
										RollUpWindow(vehuse, 0)
									elseif data2.current.value == 'menuperso_fenetres_passa' then
										RollUpWindow(vehuse, 1)
									elseif data2.current.value == 'menuperso_fenetres_gauch' then
										RollUpWindow(vehuse, 2)
									elseif data2.current.value == 'menuperso_fenetres_droit' then
										RollUpWindow(vehuse, 3)
									end
									
								end,
								function(data2, menu2)
									menu2.close()
								end
							)
						elseif data3.current.value == 'menuperso_fenetres_open' then
							ESX.UI.Menu.Open(
								
								'default', GetCurrentResourceName(), 'menuperso_fenetres',
								{
									title    = 'Ouvrir/Fermer la fenetre',
									align = 'right',
									elements = elements
								},
								function(data2, menu2)

									if data2.current.value == 'menuperso_fenetres_all' then
										RollDownWindows(vehuse)
									elseif data2.current.value == 'menuperso_fenetres_conduc' then
										RollDownWindow(vehuse, 0)
									elseif data2.current.value == 'menuperso_fenetres_passa' then
										RollDownWindow(vehuse, 1)
									elseif data2.current.value == 'menuperso_fenetres_gauch' then
										RollDownWindow(vehuse, 2)
									elseif data2.current.value == 'menuperso_fenetres_droit' then
										RollDownWindow(vehuse, 3)
									end
									
								end,
								function(data2, menu2)
									menu2.close()
								end
							)
						end
						
					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end

			if data.current.value == 'menuperso_shuff' then
				local elements = {}
				table.insert(elements, {label = 'Conducteur', value = 'menuperso_shuff_conduc'})
				table.insert(elements, {label = 'Passager', value = 'menuperso_shuff_passa'})
				table.insert(elements, {label = 'Arrière Gauche', value = 'menuperso_shuff_gauch'})
				table.insert(elements, {label = 'Arrière Droite', value = 'menuperso_shuff_droit'})
				table.insert(elements, {label = 'Autre Gauche', value = 'menuperso_shuff_autre_gauch'})
				table.insert(elements, {label = 'Autre Droite', value = 'menuperso_shuff_autre_droit'})
					
				ESX.UI.Menu.Open(
					
					'default', GetCurrentResourceName(), 'menuperso_shuff',
					{
						title    = 'Place dans la voiture',
						align = 'right',
						elements = elements
					},
					function(data2, menu2)

						
						if data2.current.value == 'menuperso_shuff_conduc' then
							SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), -1)
						elseif data2.current.value == 'menuperso_shuff_passa' then
							SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 0)
						elseif data2.current.value == 'menuperso_shuff_gauch' then
							SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 1)
						elseif data2.current.value == 'menuperso_shuff_droit' then
							SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 2)
						elseif data2.current.value == 'menuperso_shuff_autre_gauch' then
							SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 3)
						elseif data2.current.value == 'menuperso_shuff_autre_droit' then
							SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 4)
						end
						
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end

			if data.current.value == 'menuperso_porte' then
				local elements = {}
				if porteToutOuvert then
					table.insert(elements, {label = 'Tout fermer',	value = 'menuperso_vehicule_fermerportes_fermerTout'})
				else
					table.insert(elements, {label = 'Tout ouvrir',		value = 'menuperso_vehicule_ouvrirportes_ouvrirTout'})
				end	
				table.insert(elements, {label = 'Ouvrir/Fermer la porte gauche',	value = 'menuperso_vehicule_portegauche'})
				table.insert(elements, {label = 'Ouvrir/Fermer la porte droite',	value = 'menuperso_vehicule_portedroite'})
				table.insert(elements, {label = 'Ouvrir/Fermer la porte arrière gauche',	value = 'menuperso_vehicule_portearrieregauche'})
				table.insert(elements, {label = 'Ouvrir/Fermer la porte arrière droite',	value = 'menuperso_vehicule_portearrieredroite'})
				table.insert(elements, {label = 'Ouvrir/Fermer le capot',	value = 'menuperso_vehicule_capot'})
				table.insert(elements, {label = 'Ouvrir/Fermer le coffre',	value = 'menuperso_vehicule_coffre'})
				table.insert(elements, {label = 'Ouvrir/Fermer autre 1',	value = 'menuperso_vehicule_Autre1'})
				table.insert(elements, {label = 'Ouvrir/Fermer autre 2',	value = 'menuperso_vehicule_Autre2'})

				ESX.UI.Menu.Open(
					
					'default', GetCurrentResourceName(), 'menuperso_porte',
					{
						title    = 'Ouvrir/Fermer porte',
						align = 'right',
						elements = elements
					},
					function(data2, menu2)
						if data2.current.value == 'menuperso_vehicule_portegauche' then
							if porteAvantGaucheOuverte == true then
								porteAvantGaucheOuverte = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
							else
								porteAvantGaucheOuverte = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_portedroite' then
							if porteAvantDroiteOuverte == true then
								porteAvantDroiteOuverte = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
							else
								porteAvantDroiteOuverte = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_portearrieregauche' then
							if porteArriereGaucheOuverte == true then
								porteArriereGaucheOuverte = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
							else
								porteArriereGaucheOuverte = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_portearrieredroite' then
							if porteArriereDroiteOuverte == true then
								porteArriereDroiteOuverte = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
							else
								porteArriereDroiteOuverte = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_capot' then
							if porteCapotOuvert == true then
								porteCapotOuvert = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
							else
								porteCapotOuvert = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_coffre' then
							if porteCoffreOuvert == true then
								porteCoffreOuvert = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
							else
								porteCoffreOuvert = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_Autre1' then
							if porteAutre1Ouvert == true then
								porteAutre1Ouvert = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
							else
								porteAutre1Ouvert = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_Autre2' then
							if porteAutre2Ouvert == true then
								porteAutre2Ouvert = false
								SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
							else
								porteAutre2Ouvert = true
								SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
							end
						elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirTout' then
							porteAvantGaucheOuverte = true
							porteAvantDroiteOuverte = true
							porteArriereGaucheOuverte = true
							porteArriereDroiteOuverte = true
							porteCapotOuvert = true
							porteCoffreOuvert = true
							porteAutre1Ouvert = true
							porteAutre2Ouvert = true
							porteToutOuvert = true
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
							SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
							OpenVehiculeMenu()
						elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerTout' then
							porteAvantGaucheOuverte = false
							porteAvantDroiteOuverte = false
							porteArriereGaucheOuverte = false
							porteArriereDroiteOuverte = false
							porteCapotOuvert = false
							porteCoffreOuvert = false
							porteAutre1Ouvert = false
							porteAutre2Ouvert = false
							porteToutOuvert = false
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
							OpenVehiculeMenu()
						end				
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end
		
			if data.current.value == 'menuperso_radio' then
					radioZ = true
					local veh = GetVehiclePedIsIn( playerPed, false )
					SetVehRadioStation(veh, "OFF")
					
					local elements = {}
					table.insert(elements, {label = 'Eteindre la radio', value = 'menuperso_radio_off'})
					table.insert(elements, {label = 'NEBULA RADIO', value = 'menuperso_radio_nebula'})
					table.insert(elements, {label = 'NRJ', value = 'menuperso_radio_nrj'})
					table.insert(elements, {label = 'Fun Radio', value = 'menuperso_radio_funradio'})
					table.insert(elements, {label = 'Skyrock', value = 'menuperso_radio_skyrock'})
					table.insert(elements, {label = 'Virgin Radio', value = 'menuperso_radio_virginradio'})
					
					--table.insert(elements, {label = 'Radio', type = 'slider', value = 0, max = 9, options = {'OFF', 'NRJ', 'Fun Radio', 'Skyrock', 'FG Radio', 'Mouv', 'Rire Et Chansons', 'RFM', 'Virgin', 'Europe 1'}})
						
					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_radio',
						{
							title    = 'Radio Menu',
							align = 'right',
							elements = elements
						},
						function(data2, menu2)

							
							if data2.current.value == 'menuperso_radio_off' then
								TriggerEvent('radio:start', "")
							elseif data2.current.value == 'menuperso_radio_nebula' then
								TriggerEvent('radio:start', "https://listen.radioking.com/radio/373141/stream/423298")
							elseif data2.current.value == 'menuperso_radio_nrj' then
								TriggerEvent('radio:start', "http://185.52.127.155/fr/30001/mp3_128.mp3")
							elseif data2.current.value == 'menuperso_radio_funradio' then
								TriggerEvent('radio:start', "http://icecast.funradio.fr/fun-1-44-128.mp3")
							elseif data2.current.value == 'menuperso_radio_skyrock' then
								TriggerEvent('radio:start', "http://icecast.skyrock.net/s/natio_mp3_128k.mp3")
								TriggerEvent('radio:start', "http://rfm-live-mp3-64.scdn.arkena.com/rfm.mp3")
							elseif data2.current.value == 'menuperso_radio_virginradio' then
							end
							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
					
			end

			if data.current.value == 'menuperso_seatbelt' then
				TriggerEvent('esx_seatbelt:Enable')
				TriggerEvent('seatbelt:Attacher')
			end
			
			if data.current.value == 'menuperso_lockspeed' then
				func_lockspeed()
			end
			
			--if data.current.value == 'menuperso_xenonlights' then
			--	OpenXenonLights()
			--end
			
			--if data.current.value == 'menuperso_neonlights' then
				--OpenNeonLights()
			--end

			--if data.current.value == 'NeonOn' then
				--NeonToggle = true
				--local veh = GetVehiclePedIsUsing(playerPed)
				--N_0x83f813570ff519de(veh, true)
				--OpenVehiculeMenu()
			--end
			
			--if data.current.value == 'NeonOff' then
				--NeonToggle = false
				--local veh = GetVehiclePedIsUsing(playerPed)
				--N_0x83f813570ff519de(veh, false)
				--OpenVehiculeMenu()
			--end

			if data.current.value == 'menuperso_vehicule_MoteurOn' then
				vehiculeON = true
				SetVehicleEngineOn(GetVehiclePedIsIn( playerPed, false ), true, false, true)
				SetVehicleUndriveable(GetVehiclePedIsIn( playerPed, false ), false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_MoteurOff' then
				vehiculeON = false
				SetVehicleEngineOn(GetVehiclePedIsIn( playerPed, false ), false, false, true)
				SetVehicleUndriveable(GetVehiclePedIsIn( playerPed, false ), true)
				OpenVehiculeMenu()
			end				
		end,
		function(data, menu)
			menu.close()
		end
	)
end

---------------------------------------------------------------------------Modération

-- GOTO JOUEUR
function admin_tp_toplayer(target)
	--local playerPed = GetPlayerPed(-1)
	local teleportPed = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(target))))
	SetEntityCoords(playerPed, teleportPed)
	TriggerServerEvent('bot:tp_toplayerZ', target)
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputgoto == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputgoto = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputgoto = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputgoto = 0
			end
		end
		if inputgoto == 2 then
			local gotoply = GetOnscreenKeyboardResult()
			--local playerPed = GetPlayerPed(-1)
			local teleportPed = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(gotoply))))
			SetEntityCoords(playerPed, teleportPed)
			TriggerServerEvent('bot:tp_toplayerZ', gotoply)
			
			inputgoto = 0
		end
	end
end)
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome(target)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(tonumber(target)))
	local teleportPed = GetEntityCoords(GetPlayerPed(-1))
	SetEntityCoords(playerPed, teleportPed)
	TriggerServerEvent('bot:tp_playertomeZ', target)
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputteleport == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputteleport = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputteleport = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputteleport = 0
			end
		end
		if inputteleport == 2 then
			local teleportply = GetOnscreenKeyboardResult()
			local playerPed = GetPlayerFromServerId(tonumber(teleportply))
			local teleportPed = GetEntityCoords(GetPlayerPed(-1))
			SetEntityCoords(playerPed, teleportPed)
			
			inputteleport = 0

			TriggerServerEvent('bot:tp_playertomeZ', teleportply)
		end
	end
end)
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez la position...")
	inputpos = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputpos == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputpos = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputpos = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputpos = 0
			end
		end
		if inputpos == 2 then
			local pos = GetOnscreenKeyboardResult() -- GetOnscreenKeyboardResult RECUPERE LA POSITION RENTRER PAR LE JOUEUR
			local _,_,x,y,z = string.find( pos or "0,0,0", "([%d%.]+),([%d%.]+),([%d%.]+)" )
			
			--SetEntityCoords(GetPlayerPed(-1), x, y, z)
		    SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001) -- TP LE JOUEUR A LA POSITION
			inputpos = 0

		end
	end
end)
-- FIN TP A POSITION

-- FONCTION NOCLIP 
local noclip = false
local noclip_speed = 1.0

--[[function admin_no_clip()
  noclip = not noclip
  local ped = playerPed --GetPlayerPed(-1)
  if noclip then -- activé
  	
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, false, false)
	Notify("Noclip ~g~activé")
  else -- désactivé
  	
    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
	Notify("Noclip ~r~désactivé")
  end
end]]

function getPosition()
  local x,y,z = table.unpack(coords)
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

-- noclip/invisible
--[[Citizen.CreateThread(function()
  while true do
    Citizen.Wait(50)
    if noclip then
      local ped = playerPed --GetPlayerPed(-1)
      local x,y,z = getPosition()
      local dx,dy,dz = getCamDirection()
      local speed = noclip_speed

      -- reset du velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

      -- aller vers le haut
      if IsControlPressed(0,32) then -- MOVE UP
        x = x+speed*dx
        y = y+speed*dy
        z = z+speed*dz
      end

      -- aller vers le bas
      if IsControlPressed(0,269) then -- MOVE DOWN
        x = x-speed*dx
        y = y-speed*dy
        z = z-speed*dz
      end

      SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
    end
  end
end)]]
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
  godmode = not godmode
  local ped = playerPed --GetPlayerPed(-1)
  
  if godmode then -- activé
		SetEntityInvincible(ped, true)
		Notify("Mode invincible ~g~activé")
	else
		SetEntityInvincible(ped, false)
		Notify("Mode invincible ~r~désactivé")
  end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
  invisible = not invisible
  local ped = playerPed --GetPlayerPed(-1)
  
  if invisible then -- activé
		SetEntityVisible(ped, false, false)
		Notify("Mode fantôme : activé")
	else
		SetEntityVisible(ped, true, false)
		Notify("Mode fantôme : désactivé")
  end
end
-- FIN INVISIBLE

function admin_WhiteList()
  whitelist = not whitelist

  if whitelist then -- activé
		TriggerServerEvent('AdminMenu:enabled', 1)
	else
		TriggerServerEvent('AdminMenu:enabled', 0)
  end
end

-- Réparer vehicule
function admin_vehicle_repair()

    local ped = playerPed --GetPlayerPed(-1)
    local car = GetVehiclePedIsUsing(ped)
	
	SetVehicleFixed(car)
	SetVehicleDeformationFixed(car)
	SetVehicleDirtLevel(car, 0.0)
	SetVehicleFuelLevel(car, 100.0)
	exports['Nebula_Fuel']:SetFuel(car, 100.0)
	SetVehicleUndriveable(car, false)
	SetVehicleMaxSpeed(car, -1)

end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le nom du véhicule...")
	inputvehicle = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputvehicle == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputvehicle = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputvehicle = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputvehicle = 0
			end
		end
		if inputvehicle == 2 then
		local vehicleidd = GetOnscreenKeyboardResult()

				local car = GetHashKey(vehicleidd)
				
				Citizen.CreateThread(function()
					Citizen.Wait(1)
					RequestModel(car)
					while not HasModelLoaded(car) do
						Citizen.Wait(1)
					end
                    local x,y,z = table.unpack(coords)
					veh = CreateVehicle(car, x,y,z, 0.0, true, false)
					SetEntityVelocity(veh, 2000)
					SetVehicleOnGroundProperly(veh)
					SetVehicleHasBeenOwnedByPlayer(veh,true)
					local id = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(id, true)
					SetVehRadioStation(veh, "OFF")
					SetPedIntoVehicle(GetPlayerPed(-1),  veh,  -1)
					Notify("Véhicule livré, bonne route")
				end)
		
        inputvehicle = 0
		end
	end
end)
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()

    local player = playerPed --GetPlayerPed(-1)
    posdepmenu = coords--GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
	if carTargetDep ~= nil then
			platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
	end
    local playerCoords = coords--GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
	
	SetEntityCoords(carTargetDep, playerCoords)
	
	Notify("Voiture retourné")

end
-- FIN flipVehicle

local tID = nil
-- GIVE DE L'ARGENT
function admin_give_money(target)
	tID = target
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le montant...")
	inputmoney = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputmoney == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoney = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoney = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoney = 0
			end
		end
		if inputmoney == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)

			TriggerServerEvent('AdminMenu:giveCash2', money, tID)
			inputmoney = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank(target)
	tID = target
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le montant...")
	inputmoneybank = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputmoneybank == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneybank = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneybank = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneybank = 0
			end
		end
		if inputmoneybank == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('AdminMenu:giveBank2', money, tID)
			inputmoneybank = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function admin_give_dirty(target)
	tID = target
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le montant...")
	inputmoneydirty = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputmoneydirty == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty = 0
			end
		end
		if inputmoneydirty == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('AdminMenu:giveDirtyMoney2', money, tID)
			inputmoneydirty = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT SALE

-- Afficher Coord
function modo_showcoord()
	if showcoord then
		showcoord = false
	else
		showcoord = true
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		
		if IsInVehicle() == false then 
			if radioZ == true then
				TriggerEvent('radio:start', "")
				radioZ = false
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
		
		if showcoord then
			local playerPos = coords--GetEntityCoords(GetPlayerPed(-1))
			local playerHeading = GetEntityHeading(GetPlayerPed(-1))
			local entityRot = GetEntityRotation(GetPlayerPed(-1))
			Text("~r~X~s~: " .. playerPos.x.. " ~b~Y~s~: " .. playerPos.y .." ~g~Z~s~: " ..playerPos.z.." ~y~Angle~s~: " .. playerHeading .. "")
			Text("~n~~p~Rot~s~: " .. entityRot .. "")
		end
		
	end
end)
-- FIN Afficher Coord

-- Afficher Nom
RegisterNetEvent('xPiwel_showname')
AddEventHandler('xPiwel_showname', function(isAllowed)
	modo_showname(isAllowed)
end)

function modo_showname(isAllowed) 
	if showname then
		showname = false
		TriggerEvent('esx_showname:Disable')
	else
		showname = true
		TriggerEvent('esx_showname:Enable', isAllowed)
	end
end

function func_lockspeed()

	if lockspeed then
		lockspeed = false
		TriggerEvent('esx_lockspeed:Disable')
		TriggerEvent('esx:showNotification', "~y~Limitateur: ~r~OFF")
	else
		lockspeed = true
		TriggerEvent('esx_lockspeed:Enable')
		TriggerEvent('esx:showNotification', "~y~Limitateur: ~g~ON")
	end
end

function func_showcine()
	if showhud then
		showhud = false
		TriggerEvent('xpiwel:disableHud', true)
		TriggerEvent('GMz:cinema', false)
	else
		showhud = true
		TriggerEvent('xpiwel:disableHud', false)
		DisplayRadar(false)
		TriggerEvent('GMz:cinema', true)
	end
end

function func_showhud()
	if showhud then
		showhud = false
		TriggerEvent('xpiwel:disableHud', true)
	else
		showhud = true
		TriggerEvent('xpiwel:disableHud', false)
		DisplayRadar(false)
	end
end

-- TP MARCKER
function admin_tp_marcker()
	
	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group
		
		if (playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'mod') and CanAccessModeration() then
			--local playerPed = GetPlayerPed(-1)
			local WaypointHandle = GetFirstBlipInfoId(8)
			if DoesBlipExist(WaypointHandle) then
				local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())

				if IsPedSittingInAnyVehicle(playerPed) then
					entityZ = GetVehiclePedIsIn(GetPlayerPed(-1), true)
					if entityZ ~= nil then
						SetEntityCoordsNoOffset(entityZ, coord.x, coord.y, -180.0, false, false, false, true)
						Notify("Téléporté sur le marqueur !")
					end
				else
					SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
					Notify("Téléporté sur le marqueur !")
				end
			else
				Notify("Pas de marqueur sur la carte !")
			end
		end
		
	end)
end

-- FIN TP MARCKER

-- HEAL JOUEUR
function admin_heal_player()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez l'ID du joueur...")
	inputheal = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputheal == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputheal = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputheal = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputheal = 0
			end
		end
		if inputheal == 2 then
		local healply = GetOnscreenKeyboardResult()

		TriggerServerEvent('bot:heal_playerZ', healply)
		TriggerServerEvent('esx_ambulancejob:revive', healply)
		
        inputheal = 0
		end
	end
end)
-- FIN HEAL JOUEUR

-- SPEC JOUEUR
function admin_spec_player()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez l'ID du joueur...")
	inputspec = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if inputspec == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputspec = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputspec = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputspec = 0
			end
		end
		if inputspec == 2 then
		local target = GetOnscreenKeyboardResult()
		
		TriggerServerEvent('bot:spec_playerZ', target)
		TriggerEvent('es_camera:spectate', source, target)
		
        inputspec = 0
		end
	end
end)
-- FIN SPEC JOUEUR

---------------------------------------------------------------------------Me concernant

function openTelephone()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:openMenuTelephone')
end

function openInventaire()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:openMenuInventaire')
end

function openFacture()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:openMenuFactures')
end

---------------------------------------------------------------------------Actions

local playAnim = false
local dataAnim = {}

function animsAction(animObj)
	if (IsInVehicle()) then
		local source = GetPlayerServerId();
		ESX.ShowNotification("Sortez de votre véhicule pour faire cela !")
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then -- Ckeck if ped exist
					dataAnim = animObj

					-- Play Animation
					RequestAnimDict(dataAnim.lib)
					while not HasAnimDictLoaded(dataAnim.lib) do
						Citizen.Wait(1)
					end
					if HasAnimDictLoaded(dataAnim.lib) then
						local flag = 0
						if dataAnim.loop ~= nil and dataAnim.loop then
							flag = 1
						elseif dataAnim.move ~= nil and dataAnim.move then
							flag = 49
						end

						TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
						playAnimation = true
					end

					-- Wait end annimation
					while true do
						Citizen.Wait(1)
						if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
							playAnim = false
							TriggerEvent('ft_animation:ClFinish')
							break
						end
					end
				end -- end ped exist
			end
		end)
	end
end
	

function animsActionScenario(animObj)
	if (IsInVehicle()) then
		local source = GetPlayerServerId();
		ESX.ShowNotification("Sortez de votre véhicule pour faire cela !")
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then
					dataAnim = animObj
					TaskStartScenarioInPlace(playerPed, dataAnim.anim, 0, false)
					playAnimation = true
				end
			end
		end)
	end
end

-- Verifie si le joueurs est dans un vehicule ou pas
function IsInVehicle()
	local ply = playerPed --GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function changer_skin()
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:goTpMarcker')
AddEventHandler('NB:goTpMarcker', function()
	admin_tp_marcker()
end)

RegisterNetEvent('NB:openMenuPersonnel')
AddEventHandler('NB:openMenuPersonnel', function()
	OpenPersonnelMenu()
end)


RegisterNetEvent('NB:openPedMenu')
AddEventHandler('NB:openPedMenu', function()
	if CanAccessModeration() then
		OpenPedMenu()
	end
end)

RegisterNetEvent('NB:RetirerItems')
AddEventHandler('NB:RetirerItems', function(idJoueur)
	if CanAccessModeration() then
		OpenBodySearchMenu(idJoueur)
	end
end)

RegisterNetEvent('NB:changepedname')
AddEventHandler('NB:changepedname', function(model)
	if model == "origine" then
		DefaultPed()
	else
		ChangePed(model)
	end
end)


-- menu enfant
local peds_addon_child1 = {"Child","Child2","Child4","Child5","Child6","Child7","Child10","Child11","Child12","Child13"}
local peds_addon_child2 = {"kais","kais2","kais3"}
local peds_addon_child3 = {"Dante2","Dante3","Dante5","Dante6","Dante7"}


function OpenPedAddOnMenuChild()
	ESX.UI.Menu.CloseAll()
	local elements7023 = {}

	table.insert(elements7023, {label = 'Ped d\'origine', value = 0} )

	if (PlayerData.job.name == 'child' and PlayerData.job.grade == 0) or (PlayerData.job2.name == 'child' and PlayerData.job2.grade == 0) then
		for i = 1, #peds_addon_child1 do
			table.insert(elements7023, {label = "[" .. i .. "] " .. peds_addon_child1[i], value = peds_addon_child1[i]} )
		end
	end
	if (PlayerData.job.name == 'child' and PlayerData.job.grade == 1) or (PlayerData.job2.name == 'child' and PlayerData.job2.grade == 1) then
		for i = 1, #peds_addon_child2 do
			table.insert(elements7023, {label = "[" .. i .. "] " .. peds_addon_child2[i], value = peds_addon_child2[i]} )
		end
	end
	if (PlayerData.job.name == 'child' and PlayerData.job.grade == 2) or (PlayerData.job2.name == 'child' and PlayerData.job2.grade == 2) then
		for i = 1, #peds_addon_child3 do
			table.insert(elements7023, {label = "[" .. i .. "] " .. peds_addon_child3[i], value = peds_addon_child3[i]} )
		end
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menuAddOn_ped_child',
	  {
		title    = "Enfant Menu",
		align = 'right',
		elements = elements7023
	  },

	  function(data, menu)

		if data.current.value == 0 then
			DefaultPed()
		else
			ChangePed(data.current.value)
		end
  
	  end,
	  function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	  end
	)
  
end
RegisterNetEvent('NB:openPedMenuChild')
AddEventHandler('NB:openPedMenuChild', function()
	OpenPedAddOnMenuChild()
end)

-- medecin illegal
function openMenuillegal()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menuAddOn_ped_child',
	  {
		title    = "Médecin Menu",
		align = 'right',
		elements = {{label = "Soigner Blessure grave",        value = 'big'},},
	  },

	  function(data, menu)

		if data.current.value == 'big' then
			menu.close()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification("Pas de joueur à proximité")
			else
				Citizen.CreateThread(function()
					ESX.ShowNotification("Soin en cours")
					TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					Wait(10000)
					ClearPedTasks(playerPed)
					TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'harybo')
					ESX.ShowNotification("Vous l'avez soigné")
				end)
			end
		end
  
	  end,
	  function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	  end
	)
  
end
RegisterNetEvent('NB:openMenuillegal')
AddEventHandler('NB:openMenuillegal', function()
	openMenuillegal()
end)


-- menu pacific
function openMenuPacific()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menu_pacific',
	  {
		title    = "Pacific Standard",
		align = 'right',
		elements = {{label = "Give MasterCard",        value = 'give_mastercard'},},
	  },

	  function(data, menu)

		if data.current.value == 'give_mastercard' then
			menu.close()
			TriggerServerEvent("esx_menuperso:giveItem", "card_blue")
		end
  
	  end,
	  function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	  end
	)
  
end


-- menu ped animaux contrib
function OpenMenuContribAnimals()
	local peds = {
		{label = 'Ped d\'origine', value = 0},
		{label = "Sanglier", value = "a_c_boar"},
		{label = "Chat", value = "a_c_cat_01"},
		{label = "Aigle", value = "a_c_chickenhawk"},
		{label = "Singe", value = "a_c_chimp"},
		{label = "Cormorant", value = "a_c_cormorant"},
		{label = "Vache", value = "a_c_cow"},
		{label = "Coyote", value = "a_c_coyote"},
		{label = "Corbeau", value = "a_c_crow"},
		{label = "Biche", value = "a_c_deer"},
		{label = "Dauphin", value = "a_c_dolphin"},
		{label = "Poisson", value = "a_c_fish"},
		{label = "Poule", value = "a_c_hen"},
		{label = "Husky", value = "a_c_husky"},
		{label = "Cochon", value = "a_c_pig"},
		{label = "Pigeon", value = "a_c_pigeon"},
		{label = "Caniche", value = "a_c_poodle"},
		{label = "Lapin", value = "a_c_rabbit_01"},
		{label = "Rat", value = "a_c_rat"},
		{label = "Retriever", value = "a_c_retriever"},
		{label = "RottWeiler", value = "a_c_rottweiler"},
		{label = "Mouette", value = "a_c_seagull"},
		{label = "Sheperd", value = "a_c_shepherd"},
		{label = "Westy", value = "a_c_westy"}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  	'default', GetCurrentResourceName(), 'menu_animals',
	  	{
			title    = "Menu Contributeur",
			align = 'right',
			elements = peds,
	  	},

	  	function(data, menu)

			if data.current.value == 0 then
				if isAllowedToPed then
					DefaultPed()
					TriggerEvent('esx_ambulancejob:revive')
				else
					TriggerEvent('Core:ShowNotification', "Merci d'effectuer un ~y~/report~w~ afin d'être ~b~autorisé~w~ ou non à faire un PED.")
				end
			else
				if isAllowedToPed then
					ChangePed(data.current.value)
				else
					TriggerEvent('Core:ShowNotification', "Merci d'effectuer un ~y~/report~w~ afin d'être ~b~autorisé~w~ ou non à faire un PED.")
				end
			end
  
		end,
		function(data, menu)
			menu.close()
			ESX.UI.Menu.CloseAll()
		end
	)
  
end

RegisterNetEvent('NB:OpenMenuContribAnimals')
AddEventHandler('NB:OpenMenuContribAnimals', function()
	OpenMenuContribAnimals()
end)

RegisterNetEvent('Contributeur:AutoriserUnPed')
AddEventHandler('Contributeur:AutoriserUnPed', function(bool)
	isAllowedToPed = bool

	if not isAllowedToPed then
		DefaultPed()
	end
end)

