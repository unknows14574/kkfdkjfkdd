Config = {}

Config.Maintenance = false

Config.MaintenanceAllowId = {
	['steam:11000010730d690'] = true , -- B3N
	['steam:11000013b0b22ef'] = true , -- ROX
	['steam:1100001059e43ec'] = true , -- xPiwel
	['steam:11000011be6c786'] = true , -- Sky
	['steam:11000010c81521e'] = true , -- Bat45Bat
	['steam:11000010a055fb0'] = true , -- SCN
	['steam:1100001076748c2'] = true , -- Pastèque
	['steam:11000011551f0d2'] = true , -- Stony
	['steam:110000104649d19'] = true , -- Strive
	['steam:11000013713839e'] = true , -- ARIA
	['steam:1100001051b48ab'] = true , -- Gio
	['steam:11000014a6f77e2'] = true,  -- Shannon miller
	['steam:110000110eeac10'] = true,  -- Jaden Davis
	['steam:11000011cc6a03b'] = true,  -- Aaron Keener
	['steam:1100001119f7992'] = true,  -- Louis Hyde
	['steam:1100001329c0a59'] = true,  -- John Renald
}

Config.Keys = {
	["ESC"] = {id = 322, input = "INPUT_REPLAY_TOGGLE_TIMELINE"}, 
	["F1"] = {id = 288, input = "INPUT_REPLAY_START_STOP_RECORDING"}, 
	["F2"] = {id = 289, input = "INPUT_REPLAY_START_STOP_RECORDING_SECONDARY"}, 
	["F3"] = {id = 170, input = "INPUT_SAVE_REPLAY_CLIP"}, 
	["F5"] = {id = 166, input = "INPUT_SELECT_CHARACTER_MICHAEL"}, 
	["F6"] = {id = 167, input = "INPUT_SELECT_CHARACTER_FRANKLIN"},
	["F7"] = {id = 168, input = "INPUT_SELECT_CHARACTER_TREVOR"}, 
	["F8"] = {id = 169, input = "INPUT_SELECT_CHARACTER_MULTIPLAYER"},
	["F9"] = {id = 56, input = "INPUT_DROP_WEAPON"},
	["F10"] = {id = 57, input = "INPUT_DROP_AMMO"},
	["~"] = {id = 243, input = "INPUT_ENTER_CHEAT_CODE"},
	["1"] = {id = 157, input = "INPUT_SELECT_WEAPON_UNARMED"},
	["2"] = {id = 158, input = "INPUT_SELECT_WEAPON_MELEE"},
	["3"] = {id = 160, input = "INPUT_SELECT_WEAPON_SHOTGUN"},
	["4"] = {id = 164, input = "INPUT_SELECT_WEAPON_HEAVY"},
	["5"] = {id = 165, input = "INPUT_SELECT_WEAPON_SPECIAL"},
	["6"] = {id = 159, input = "INPUT_SELECT_WEAPON_HANDGUN"},
	["7"] = {id = 161, input = "INPUT_SELECT_WEAPON_SMG"},
	["8"] = {id = 162, input = "INPUT_SELECT_WEAPON_AUTO_RIFLE"},
	["9"] = {id = 163, input = "INPUT_SELECT_WEAPON_SNIPER"}, 
	["-"] = {id = 84, input = "INPUT_VEH_PREV_RADIO_TRACK"},
	["="] = {id = 83, input = "INPUT_VEH_NEXT_RADIO_TRACK"},
	["BACKSPACE"] = {id = 177, input = "INPUT_CELLPHONE_CANCEL"},
	["TAB"] = {id = 37, input = "INPUT_SELECT_WEAPON"},
	["Q"] = {id = 44, input = "INPUT_COVER"},
	["W"] = {id = 32, input = "INPUT_MOVE_UP_ONLY"}, 
	["E"] = {id = 38, input = "INPUT_PICKUP"},
	["R"] = {id = 45, input = "INPUT_RELOAD"},
	["T"] = {id = 245, input = "INPUT_MP_TEXT_CHAT_ALL"},
	["Y"] = {id = 246, input = "INPUT_MP_TEXT_CHAT_TEAM"},
	["U"] = {id = 303, input = "INPUT_REPLAY_SCREENSHOT	"},
	["P"] = {id = 199, input = "INPUT_FRONTEND_PAUSE"},
	["["] = {id = 39, input = "INPUT_SNIPER_ZOOM"},
	["]"] = {id = 40, input = "INPUT_SNIPER_ZOOM_IN_ONLY"}, 
	["ENTER"] = {id = 18, input = "INPUT_SKIP_CUTSCENE"},
	["CAPS"] = {id = 137, input = "INPUT_VEH_PUSHBIKE_SPRINT"},
	["A"] = {id = 34, input = "INPUT_MOVE_LEFT_ONLY"},
	["S"] = {id = 8, input = "INPUT_SCRIPTED_FLY_UD"}, 
	["D"] = {id = 9, input = "INPUT_SCRIPTED_FLY_LR"},
	["F"] = {id = 23, input = "INPUT_ENTER"}, 
	["G"] = {id = 47, input = "INPUT_DETONATE"},
	["H"] = {id = 74, input = "INPUT_VEH_HEADLIGHT"},
	["K"] = {id = 311, input = "INPUT_REPLAY_SHOWHOTKEY"},
	["L"] = {id = 182, input = "INPUT_CELLPHONE_CAMERA_FOCUS_LOCK"},
	["LEFTSHIFT"] = {id = 21, input = "INPUT_SPRINT"},
	["Z"] = {id = 20, input = "INPUT_MULTIPLAYER_INFO"},
	["X"] = {id = 73, input = "INPUT_VEH_DUCK"},
	["C"] = {id = 26, input = "INPUT_LOOK_BEHIND"},
	["V"] = {id = 0, input = "INPUT_NEXT_CAMERA"},
	["B"] = {id = 29, input = "INPUT_SPECIAL_ABILITY_SECONDARY"}, 
	["N"] = {id = 249, input = "INPUT_PUSH_TO_TALK"},
	["M"] = {id = 244, input = "INPUT_INTERACTION_MENU"},
	[","] = {id = 82, input = "INPUT_VEH_PREV_RADIO"},
	["."] = {id = 81, input = "INPUT_VEH_NEXT_RADIO"},
	["LEFTCTRL"] = {id = 36, input = "INPUT_DUCK"}, 
	["LEFTALT"] = {id = 19, input = "INPUT_CHARACTER_WHEEL"}, 
	["SPACE"] = {id = 22, input = "INPUT_JUMP"}, 
	["RIGHTCTRL"] = {id = 70, input = "INPUT_VEH_ATTACK2"},
	["HOME"] = {id = 213, input = "INPUT_FRONTEND_SOCIAL_CLUB_SECONDARY"},
	["PAGEUP"] = {id = 10, input = "INPUT_SCRIPTED_FLY_ZUP"}, 
	["PAGEDOWN"] = {id = 11, input = "INPUT_SCRIPTED_FLY_ZDOWN"},
	["DELETE"] = {id = 178, input = "INPUT_CELLPHONE_OPTION"},
	["LEFT"] = {id = 174, input = "INPUT_CELLPHONE_LEFT"}, 
	["RIGHT"] = {id = 175, input = "INPUT_CELLPHONE_RIGHT"},
	["TOP"] = {id = 27, input = "INPUT_PHONE"}, 
	["DOWN"] = {id = 173, input = "INPUT_CELLPHONE_DOWN"},
	["NENTER"] = {id = 201, input = "INPUT_FRONTEND_ACCEPT"},
	["N4"] = {id = 108, input = "INPUT_VEH_FLY_ROLL_LEFT_ONLY"}, 
	["N5"] = {id = 60, input = "INPUT_VEH_MOVE_UD"},
	["N6"] = {id = 107, input = "INPUT_VEH_FLY_ROLL_LR"}, 
	["N+"] = {id = 96, input = "INPUT_VEH_CINEMATIC_UP_ONLY"},
	["N-"] = {id = 97, input = "INPUT_VEH_CINEMATIC_DOWN_ONLY"},
	["N7"] = {id = 117, input = "INPUT_VEH_FLY_SELECT_TARGET_LEFT"}, 
	["N8"] = {id = 61, input = "INPUT_VEH_MOVE_UP_ONLY"},
	["N9"] = {id = 118, input = "INPUT_VEH_FLY_SELECT_TARGET_RIGHT"},
}

Config.keyDefaults =
{
    -- Menu Principal
	menu_principal = "f1",

	-- -- Téléphone
	-- phone = "f2",

	-- Menu Animation
	menu_animation = "f3",

	-- Changer distance voix
	voix_distance = "f5",

	-- Menu Job
	menu_job = "f6",

	-- Afficher/Cacher HUD
    hud = "f7",
    
    -- Vérouillage Véhicule
	vehicule_lock = "f9",

	-- Coffre Véhicule
	vehicule_coffre = "f10",

	-- Véhicule Ceinture
    vehicule_belt = "k",
    
    -- Véhicule Clignotant droite
    -- clignotant_left = "left",
    
    -- Véhicule Clignotant gauche
    -- clignotant_right = "right",
    
    -- Véhicule Clignotant warning
	-- clignotant_warning = "down",

	-- Véhicule activer régulateur de vitesse
    vehicule_regulateur = "x",
    
    -- Véhicule monter régulateur de vitesse
    vehicule_regulateur_up = "up",
    
    -- Véhicule descendre régulateur de vitesse
	vehicule_regulateur_down = "down",

	-- Menu masque
	menu_masque = "oem_3",

	-- Ouvrir/Fermer la radio
	radio = "pageup",
	
	-- Mute/Unmute la radio
    OnOffradio = "END",

	-- Mute/Unmute radio speaker
	Speaker = "y",
    
    -- Menu Stamina
    menu_stamina = "pagedown",

	-- Ragdoll, Tomber par terre
	ragdoll = "u",

	-- Pointer du doigt
	pointing_fingers = "b",

	-- S'allonger
    allonger = "delete",
    
    -- S'accroupir
	accroupi = "lcontrol",

	-- Lever les mains
    handsup = "rbracket",

    -- Siffler
	siffler = "h",
    
    -- Holster
    holster = "m",

    -- Croiser les bras
	croiser_bras = "comma",

	-- Main sur la tête
	hand_on_head = "period",

	-- Arreter animation
	stop_animation = "z",

	-- Ouvrir Tablette
    tablet = "plus",

    -- Activer Interaction
	interaction = "insert",
	
	-- Claque
	claque = "SLASH",
	
	-- Siren
	siren = "z",
	
	-- Pousser Véhicule
	vehiclepush = "c",

	-- Crever Pneu
	creverpneu = "e",
	
	-- Dans le coffre
    InTrunk = "l",

	-- ToggleSiren
    toggleSiren = "3",

	-- Toggle sound siren
    toggleSoundSiren = "2",

	-- Change sound siren
    changeSoundSiren = "1"
}

Config.density = {IsEnable = true, densityGlobal = 1.0, densityPieton = 1.0, rangeDensity = 1.0}

Config.CleanZone = {
    {ClearArea = true, x = -43.78, y = -1098.36, z = 27.27, Distance = 10.0}
}

Config.ClearPed = {
	{ClearPed = false, x = -1116.84, y = 4923.57, z = 217.94, Distance = 100.0, Flags = 1},
	{ClearPed = true, x = -1626.33, y = 4562.76, z = 43.36, Distance = 50.0, Flags = 1}
}

Config.Discord = {
	Enable = true,
	DiscordToken = "OTAxNTgwNTc5NTY3NDM1ODQ3.YXR8WA.EqiPAFZJjwLXlFplf-kuimSmUPk",
	GuildId = "593614869513633815",

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["🍂 FiveM"] = "636562522169802762",
		["🍂 Whitelist II"] = "1038911902069309480",
		["🍂 Wipe/Autre"] = "707647169460568144",
		["📱 Contributeur #3"] = "637263653833539585",
        ["📱 Contributeur #4"] = "722603764393181286",
        ["📱 Contributeur #5"] = "756842963740393493",
        ["📱 Contributeur #6"] = "756843450787299399",
		["📱 Contributeur #7"] = "756861681602134106",
		["📱 Contributeur #8"] = "756879416629526618",
		["📱 Contributeur #9"] = "760534100930330715",
		["📱 Contributeur #10"] = "760534201664798722",
		["📱 Contributeur #11"] = "760534205972873226",
		["📱 Contributeur #12"] = "760534354400378901",
		["📱 Contributeur #13"] = "760534356363182090",
	    --["👤 Joueur"] = "606301940933984266", -- This would be checked by doing exports.discord_perms:IsRolePresent(user, "TestRole")
	},

	Log = {
		--Pour activer les logs, ne pas oublier de mettre la ligne juste en dessous dans le cfg
		--  set Discord_Log "true"
		-- set Discord_Log_Is_Dev "true" pour mettre le mode DEV (dans les logs afficheras [SERVEUR DEV] sur chaque logs!)
		Active = GetConvar("Discord_Log", "false") == "true" and true or false,
		IsDev = GetConvar("Discord_Log_Is_Dev", "false") == "true" and true or false,

		TimeToSendNewWeponAlert = 5000,

		Color = {
			Green = 56108,
			Grey = 8421504,
			Red = 16711680,
			Orange = 16744192,
			Yellow = 16776985,
			Blue = 2061822,
			Purple = 11750815,
			Blue_Dev = 	3008235, 
			Pink = 	16711834, 
			Black = 16777215
		},
	
		WebHook = {
			-- Logs de modération --
			["Le serveur a redémarré!"] = "https://discord.com/api/webhooks/901235632880357427/ieuQXgeBE8Fqbgo2nmsADtSKiQocpo4VfaZbkkNJ5DGtZiY0RNMAByqqPx2yntSHiXDu",
			["Annonces modérateurs"] = "https://discord.com/api/webhooks/789907718794248212/x_KBTLQKqvFxH4Z21AHyYtjM57ha0i9t8cA0Ik3g-_enCwZ4pSMU_LZVtgSKibscwyyp",
			["Stop Chat"] = "https://discord.com/api/webhooks/789909278168973322/c-30sgxyyc4q96Q1C4ccmB3574uVjwL97SSWNNZ8_UmT4mODa4ccJ2vPsAaSNGsoGNTB",
			["Pointage Modérateurs"] = "https://discord.com/api/webhooks/773231192325619794/0CBCSKRDjp2IM1SPaFnxOddV5A8KRcaH6LDfsaPQEcRoBcAEOm44-BDr5fKUPc8oJUYZ",
			["Pointage Helpeurs"] = "https://discord.com/api/webhooks/780808737736622100/GME_ZNHcp7qViDwdO29dfe3DTQuE39JlvenNt3arUJgV1n9Lmfq1Cdx69MFa7iNepQJg",
			["Connexion / Déconnexion"] = "https://discord.com/api/webhooks/773237328348315720/9SGCGXO80wUAe0avhA976nxMjb6drwA3SsAzeuX7-DCmT6GwSp7lW6IOhgeNqZXrGa6B",
			["Mode spectateur"] = "https://discord.com/api/webhooks/773239985397956620/l0kXZFEG4NdpkZddFQNMdypKa1uGFeqvKPenqTnTEAZXYrPGMWHsTnzof4u4wPY5hLLt",
			["Morts / Suicides"] = "https://discord.com/api/webhooks/773240164084219944/NcRz2h51Rq4mABYKg8ViN0hMjDE2uEevke0wJM_mpXFxwkdqoAjAP5UFy8KvbQkfrH8Z",
			["Tirs"] = "https://discord.com/api/webhooks/773240397710491649/iD4mG-_LZo0DbAtwaqjMEPBQ9EZTwsEMHdX_98C-lcWGDwBihx5_2C2Ytq7i6sMx770t",
			["NoClip"] = "https://discord.com/api/webhooks/773978682741358622/mAo1KSwakQKhsarwWEC4SehZ83Gr4SvrUCoK-Ce4OTYWc8ZqaXRBpmcTK8Nx2rJ1lzMd",
			["SetJob"] = "https://discord.com/api/webhooks/967811764051906620/gGxBBZw1HbzleUXuGLtLgFUMuqM5qtxNNmxyokBC5q4mCN8GTSjUToqgLU-DWhoDiar7",
			["Réanimation"] = "https://discord.com/api/webhooks/774010083599188021/ecdgEKnQ4BWdd6qvjF6ogt8s0uSZ7CsWIC9_eLkIBqsEBP7VXn6MTIw7UgMSqllEQ3WK",
			["Afficher / Cacher Noms"] = "https://discord.com/api/webhooks/774010043901280286/dLsi9mWoQ5hPhF1Svw0bx-lPHN6nbiVAFiquJS2Vp4pqDnEkGelCASE_Rx5ZZEM7Qvqs",
			["Téléporation"] = "https://discord.com/api/webhooks/774343104496664589/UiXGx5a1XkUIJ88sSdLONzT78XdCxBk8B069hNljap6J27VVM430sEnu1cj54hlKJqCk",
			["Apparence"] = "https://discord.com/api/webhooks/774346151386153014/9pvt9ghQuX2csJfLq4BUe1WZ3IL_AhFh6YH0ygOxNEx_rGtWjQUloFzQCLurKJQxAamx",
			["Give Items / Argent / Armes"] = "https://discord.com/api/webhooks/774806913321533461/Iv_ccDBGRYzvg8YH9Qh98TaSLM7Q9E6Zzc2rBoOUUSXovJ-mFtvjV4xzKvQdzjbSjYN_",
			["Spawn de véhicule"] = "https://discord.com/api/webhooks/774819587430547476/xgbyAyseiqxnXDkp_gVfoeM4qjqOoFBAyK4eFSzH0JAj8XnqXrzfx95_C-zkrwetnWcZ",
			["Réparation de véhicule"] = "https://discord.com/api/webhooks/774827129842040873/vkKA-S1VEJA7-QrxkFj6MXnEcEJ4hl65lB40vqqrcztQJaeEDG95cfySSV0whrQLpawL",
			["Report"] = "https://discord.com/api/webhooks/756292984584273991/WdgqCTvjMwvW4qBxc_55X2XkeVCOFn492zfnTL4Pr2zYf_eLaEzweZCEM04zokMg92uA",
			["Reply"] = "https://discord.com/api/webhooks/756292984584273991/WdgqCTvjMwvW4qBxc_55X2XkeVCOFn492zfnTL4Pr2zYf_eLaEzweZCEM04zokMg92uA",
			["Wipe"] = "https://discord.com/api/webhooks/792912817610293248/A36qiaR95_kmArcwkKfwE0OUQXO6uQhV8WRoTbVZFbvKDsh6XzvSDSB4AnDyY5gSijsR",
			["/me"] = "https://discord.com/api/webhooks/812418038472245358/uWEU3Xn7hXGx47WfnmBFFmI2E2RtC2ZXOotxdQ0hgDEF8BzsY1jC0cZBo0BuOqjQo7S_",
			["PED Contributeur"] = "https://discord.com/api/webhooks/820727190903455774/n7bGI_LTpns04aoJr8AWxaUY29D2xPkPYZMrVoVt78MEMCr9VJ4JuP_5qBi2mqh2Qnj3",
			["Tentative de duplication"] = "https://discord.com/api/webhooks/646120161686061077/xgQxsx1ixEa7wW-M5FVoX0UE-jqOLJIsSQflOgbkPAM_qP7E1pSK-qOf4tJMi0a26liz",
			["Coffre propriétés"] = "https://discord.com/api/webhooks/852270782490214470/zPnNRylW1jC-ozwVeEfA6TqK3z35ZrlER407sg9BD7WmZM2M-jWy61pMcit-ICyVXLWp",
			["Utilisation gilet par balles"] = "https://discord.com/api/webhooks/854042417425416192/tG9N84SoWZgq8X0brXRK3HYf64wFEapa39SXvF3EW9t-yksZ3dcOxZrQyoZ27-eGzCVg",
			["Utilisation super carotte"] = "https://discord.com/api/webhooks/985633712521768970/BmYHLdbtY1x-Kdx_Fwc_S70tkQZp2XASvVH5TnYItUzvqiQcWAVon2wT4aqR04jZJOkc",
			["Coffre Admin"] = "https://discord.com/api/webhooks/1025528614340526160/UKPN89jT9YyMRLvcvP30u09hr6Bsci8u3wdcdQSSAkX5DDvzDdT-cjcZRSerQLqGA6ss",

			-- Dev
			["Script error"] = "https://discord.com/api/webhooks/843608255112019999/MPZWedxQSC3oC2-R1-OI5E9-vVA2cprz9pGR5f24FoAgD2_hW1HEwezN68F7MBm0sczK",

			-- Illégal
			["ATM"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Largages"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["GoFast"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Braquage banque"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Braquage entreprise"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Braquage coffre superette"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Braquage APU"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Braquage bijouterie"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Carjacking"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Mission de deal"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["BRINKS"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Changement de plaques"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Achat armes lourdes"] = "https://discord.com/api/webhooks/801534999107076096/bfIVGqqgTHNL6dKJRbAVzpZayT4CgJ90-YICz7_MhSba6a1qSE2qh7AH18-5ZrmXM2Xg",
			["Achat armes légères"] = "https://discord.com/api/webhooks/801535609218138112/wSBD4NABkjnjiOut8ZiE8WtyKBjxZmhB--lNAg53roNzNa1Myrq2iI9dXEYfBJi1QbBw",
			["Achat armes normales"] = "https://discord.com/api/webhooks/801535651722952764/ujIZyLas2JXDK2Wx5NUA0JxSEmiJ81Hyd6PzeuK0oBvl1GR_XirK2OxpywpqzGnbLJFQ",
			["Achat gilets par balles"] = "https://discord.com/api/webhooks/854042518311665694/fHf8O-VQ52GLHXLf2XpAUCuLL6JM1G-P_7zpEWrdlqHjV1Rl-ESp5g-ioWp0OajtCI8c", 
			["Achat véhicule"] = "https://discord.com/api/webhooks/841357531812069407/IRganu0JxWLrdoKp6NZ4aTknfV-buCEz8gr89Qt9uyLWmSQ8XQZEC3mXu0RfJJLsqle3", 
			["Braquage Yacht"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF",
			["Cambriolage"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF", 
			["Coupe bracelet"] = "https://discord.com/api/webhooks/789921420367888394/H5yejSB1qpy69HXe2O_6JsZadCUD4_P0nS11OXXtETkTQPeo8x7Se5iGDTPndepZrofF", 
			["Receleur véhicule"] = "https://discord.com/api/webhooks/1025528454650794086/u1FDieFP34-Q5ehNZbdPoVQdlzD-bGqQvlVrXXJB2Pm_CkZm54D-a9rUiMdX28Zo_tM1",
			["Cuivre"] = "https://discord.com/api/webhooks/1027268697288622200/rvrN0i-LGqOvveWNqaaIwHGNiLYkjvR9epvwDOQ_Zeyd67Xp1fCyk4pL_FMTBf_35eV5",

			["Centrale 911"] = "https://discord.com/api/webhooks/950103766756118578/W7qpXc1vIKfAmRQMsZELYbxfVPSvbK7lrF1m9GOWsZqQ8arAeAP9XqrjxsyipD636KpE",

			-- Logs d'intéractions joueurs -- 
			["Échange d'objets"] = "https://discord.com/api/webhooks/776142144347439176/L9SHLdckIrYNldDnhm-MzAudSyzsGQ3glPX0L09E_5JZcyrCxV8Iy-vESj8v7EXQElZh",
			["Échange d'argent"] = "https://discord.com/api/webhooks/776142215298416640/_Xe2L4T-fyD4ju1Wgg-M98G9ydFdyKOsqxLzECRNB7wSIrCYqN8YdEQXnCLMZWMtbkcy",
			["Échange d'arme"] = "https://discord.com/api/webhooks/776142254426554409/wfAYo_W98pPJA3iDstHfP2BOr_vfYWiq7rZE11tpGCrs4Nit9NlsG-3GmGd_Z3VTWYEr",
			["Coffres de véhicules"] = "https://discord.com/api/webhooks/836340126535647242/bhNDphuCyWmwCFdHnc1k59NoBzr034FHBCQL5gwYGxSkLtZbfNRL9e5m7YP5t7PUjT_P",
			["Préfécture - don de véhicule"] = "https://discord.com/api/webhooks/998747088168951808/c0LWiY3jlNtAN7KsD98gQ0YdSrd9G_OHu5EO6JTiT3hxkiOXl_yb_qvn22nljQGiZTJs",

			
			-- Logs d'intéractions Illegal --
			["Coffre d'argent sale"] = "https://discord.com/api/webhooks/986311893134229514/GMB1L6YlSxMylNy61_LjfBOGh-mar9AsnSsZmzq8A9pheTCxkXEVAJff5O8eiCaXAIaq",
			["Coffre d'argent propre"] = "https://discord.com/api/webhooks/986312019055616030/xv-UhucejDBJR13zX9PnaBseOKejbQOR3jFpnFe0fn66rcmc4iUGrB9vgtrIBr3UtZGo",
			["Coffre d'armes"] = "https://discord.com/api/webhooks/986311709746683984/WlGZ8ezjlGnx3Ca7SWg8osRVUOcKKkr4hHnVc_KOhkduTOZqNIXl-RAsc5URcg04hIkg",
			["Coffre d'objets"] = "https://discord.com/api/webhooks/986312119383388201/KTYvDRqxtn_gkXyfqH6u44hK6usbUHDMIXQtUXamZjLTSsxCPQodlGEvCiQyutxH1_5g",

			-- FISC -- 
			["Dépot entreprise"] = "https://discord.com/api/webhooks/793867464534261781/Rrt74IWGLd8kE2_wlQpv8mNrCdPVEmbr9mxpO6xg_wFSy2Xb-8hRiCVzM_rmgyDuFMXL",
			["Retrait entreprise"] = "https://discord.com/api/webhooks/793867871356321792/1ATVinM8dADbv-4ZOOUjFisncUA7lPqQn6s-elhta5TlmggQ3ZnuF1yfNpvmcpOXukXM", 
			["Virement entreprise"] = "https://discord.com/api/webhooks/793868056359075881/LLOaADbHOEDSG_2jM38tyVCzNvJP4Hl2S6eHGw2OO6hGC5Fk-ykwgDaW-dI00JhIvB9o",
			["Paiement facture enteprise"] = "https://discord.com/api/webhooks/793868381136093244/5ErlGIwLUnZDqwyrCCdVb7nTn0ov4rTZOT2ycqga2XO_xrKvCOyHQtPyXawb-uBNCOIi",
			["Dépot personnel"] = "https://discord.com/api/webhooks/793868412375400469/k9okyVaAj341bW2P-H3_PvaTw8WR51rSaJHGBNsBhN80OkPrnDRoVQGkkTcABRVQGNJ0",
			["Retrait personnel"] = "https://discord.com/api/webhooks/793868473570033715/X11sL0TEv1bP0odDRM35tpjiaEnZ3peq94o00t0cqX5T8khObX9ZibL3e4e30KMxX8e-",
			["Virement personnel"] = "https://discord.com/api/webhooks/793868629544140820/NHR1MhFVhC1EhThaW8O4K3uS-NB8F7f-d6iZ7OpKFKHJNvGij0Z295BqXdzX_95cDpV4",
			["Paiement facture personnel"] = "https://discord.com/api/webhooks/793868525622132746/CzQgTNfSP-Fz1549oxUjpshBOJOUUweLpwXSEnMuGMfMQgBuYy3EgUoSy2ckS50J5x8G",
			["Achat superettes"] = "https://discord.com/api/webhooks/832338183936540703/MqRJdGfymBFkFbEuNGu6S3fnVbhNzHroi3BUD2f9PIBCcv7a7LCDAe7J1JaTbieqtQL3",
			["Achat armurerie"] = "https://discord.com/api/webhooks/951680284183642122/fNlrHFsoOK51WxVJjgysTV25XIpLV9uAQUx8XNZMlYFkzDggLhqW06lAegjBHzAz-QhX",

			-- Entreprises
			["Tequi-La-La"] = "https://discord.com/api/webhooks/800630424774639636/a3nyASx0CvI93kZFvvkcSwi662_VxpT_qcP_YeoFOMjrsYHo1r9vNs5UMnqJ9GZ-Zhbx", -- Sur discord Tequi-La-La
			["Tequi-La-La - Factures"] = "https://discord.com/api/webhooks/800630463227101185/ZqICHMmsdvnBlpcGysE5c9Z9cu43x_APOcNQOjgUFxynqnIq05icueMkU5yJT-20IOLU",
			["Tequi-La-La - Service"] = "https://discord.com/api/webhooks/800630504298381323/M0BXEsNsbKpwnXAJzXkoGqRjn398WTrX-Tc2RFZaGmx8-7xEOFbNpf5ErsogpvuYH_Vi",
			-- 
			["Gouvernement - Coffre"] = "https://discord.com/api/webhooks/786312004356014090/9MfK4V8jrYO4p9UCxXlDpmgfoXQrZstG8D9JnghacMqf2mIc2Mc2nPn1kbCEVL07tE0W",
			["Gouvernement - Factures"] = "https://discord.com/api/webhooks/789916950741647412/WdUN2HMdFReTD_VsMKp_nLMdD9m2_r_HZsFEZ_UnesKh9pL6iFkeoq0mggCAbm8b6r6m",
			["Gouvernement - Service"] = "https://discord.com/api/webhooks/789972395569577994/n-OHJnG1yN5ip8urM3dBQ02kKusZ6e0B9Lhcs6Ss1OU_LNxEDFsuJD-8f8awBjrRtr6x",

			--

			["Prison- Coffre"] = "https://discord.com/api/webhooks/849758536623849493/EM2huT8U57OnxeFSHmHjYa7j6TcyAAG30GGC6-BvN2Q_Uu7By-Xt2IEUH6EK8rUwl09M",
			["Prison- Service"] = "https://discord.com/api/webhooks/849758587835252767/YxMC0RDBQwZUAJ-WOHDaxA3T6yUjg2WHL92qNNYEY2azzhYZYCQA89db-vL4UMfGzuQh",
	
			--
			["Weazel News - Annonces"] = "https://discord.com/api/webhooks/789904201035284501/2L_s_jbDKHxgnCLxGGJDgQ6T5fjC9gWFblrw_MufQRApUNOuS1gzQl2Ona2NW9m4i_xn",
			["Weazel News - Coffre"] = "https://discord.com/api/webhooks/789907502371307540/XQPljK_egDGBRG2KoNnrLvoAoFyRr05ESk9kxPxaOSepGrjTgTaL39dhySUlqNrYUq_B",
			["Weazel News - Factures"] = "https://discord.com/api/webhooks/789912370696814592/7ZzXqkulbVZHGroh3g4KW6tydTwNouzgnaXfO8DPH4qidk89HwKc2Jag_KUN-rcKVIAx",
			["Weazel News - Service"] = "https://discord.com/api/webhooks/789971591311523840/6E9Qx5UFAXFmDuaDerbf2lqV9kEgzkCITrB5-hYqxaTdTvPmq_AzdJbX0vA93Dkn2txF",

			--
			["Music Record - Coffre"] = "https://discord.com/api/webhooks/951513455972712529/K8NOMTCMApLPwU1RXVQkvZ7_KXBrJRMMZYg9E3J9Q1OqgnBkUbkpYYI0TlRG7IgeMjA6",
			["Music Record - Factures"] = "https://discord.com/api/webhooks/951513493415264285/auKm8b-wB5lQXpkIjex8h54i_94lx1DMA7orl6PKsMbUfTk3PT_6uodvyffhcxO5Lbs0",
			["Music Record - Service"] = "https://discord.com/api/webhooks/951513530195148820/sqI_KsIv_6yIawUADTAMcAjWpAB_1G7lA_45vtg4XJONaALuznoP6zeuITBFEkpQncOW",

			--
			["Arcadian Bar - Coffre"] = "https://discord.com/api/webhooks/936295078014644224/dw2u_D_4SdUxuq7-bXhsscask9YX6NfcL9mmBPGUQBExwsEcD66i7fF1CAi0j2JM3Bgw",
			["Arcadian Bar - Factures"] = "https://discord.com/api/webhooks/936295044997083186/upbl7XIDeYOS--prOywPwUHRSID3FOepGP5iNyrGVHmAdAaZwMWP7zUKyu9sSlVPVSEh",
			["Arcadian Bar - Service"] = "https://discord.com/api/webhooks/936295008993157220/2L4QirhSJSJbKRWln_VyCSGsxXMD3VZhhomlzqXSX_EiKcLORmwna1K42T_b0UqWeBrR",
			["Arcadian Bar - Tickets"] = "https://discord.com/api/webhooks/936294962855829584/L2InFWL3b3DNZjsKh3JFHOu1igkYhoIbBvveD11TPGoZUZlF0tC8CVYujPOQXN2DQoQX",

			--
			["Gruppe6 - Coffre"] = "https://discord.com/api/webhooks/942942246972567593/ju4NGNczzPmiCMd7qhC76TVsCVBCZxfzf2NbALbS_Qa_M9NQgPVmflRyTybmYOfe4eaL",
			["Gruppe6 - Factures"] = "https://discord.com/api/webhooks/942942327587086346/dz_NFT3OzqNRAXS8Gl4BFdwYMSbNX8Rw-U8iHf0VL8iWter2GxVUA2q0ohPyAWHkSWJW",
			["Gruppe6 - Service"] = "https://discord.com/api/webhooks/942942362894757898/mMmoLTO4r4djMPTr5dOeFrWJfov9l38YzLj9Z94yGfwXDqhHNlT8VP3QPZ61-cRKNvzs",
			["Gruppe6 - Armurerie"] = "https://discord.com/api/webhooks/942942287028170773/0yHdw8Ps0sxMxEiuccCmkY5i1Lkf2IxAOlc8fkmRMOTYsBuZ0ALPolNurn46dnWqd8xb",
			
			--
			["Up N Atom - Coffre"] = "https://discord.com/api/webhooks/936699036340211722/o_-sQ_xNemumouJsDpHNavRSLShZZCzYJf-iWH2EUDvOta8cADdbh2xqgnQR3jRbn3e4",
			["Up N Atom - Factures"] = "https://discord.com/api/webhooks/936699065276694579/gM20uE0Urf68XhC6h8SMFICmG2i5n9-L8NEKyhJfj_fnZ8N26XCMVLr4-onM3WOTSugf",
			["Up N Atom - Service"] = "https://discord.com/api/webhooks/936699138622496768/ZHO5zg4VyvrpJ4g1hebt18UjqcJ7QE6IJnDkGMy6guQTJOps3DSaFghrvWJ0cX4AmTbY",
			
			--
			["Unicorn - Coffre"] = "https://discord.com/api/webhooks/936302789573869570/Sa27_AzCSGjfbnh84URSBadgC-SNFKznUKenxNdmAHMvIrwxLsDSEnrQRcqalRaeGa3Z",
			["Unicorn - Factures"] = "https://discord.com/api/webhooks/936302757319680081/wS4YTXpeZ7owDXIa72U83BnyIoUE2J20J1phgw_RE8agJE4Gd3gQC3PLclubFMdCT0PD",
			["Unicorn - Service"] = "https://discord.com/api/webhooks/936302722410504213/hdYMrDaai9JjG_anV3wQLrCplUSUl83yvu6u4Y62l-UOyIa046nsOYQ9NgalAGSTjR0i",

			--
			["Le Phare Ouest - Coffre"] = "https://discord.com/api/webhooks/936305555495063622/3N_f5kVH8otQl1N7sNR8UnkzcF8A9BnhGNqDJAx77xT-lrI4z9wvT_tEewcSlGtu0gVI",
			["Le Phare Ouest - Armurerie"] = "https://discord.com/api/webhooks/936306825358360626/GE2BtgseWk_wuRKfYXONKa3iY0ZZjRJlOUHUQkLdS9w5fSqcbefiSLgeEa469-3mx74q",
			["Le Phare Ouest - Factures"] = "https://discord.com/api/webhooks/936305621060444260/pV7TYRR2cWs_mAlMpJYFoRstW54ZXt1-INPyBEtGeDHHIxUCHNJAusa4yt3LE1FuqoUP",
			["Le Phare Ouest - Service"] = "https://discord.com/api/webhooks/936305699405824011/GZhsXyTaN4bnQsU1eMhV58xGpCHX9ewEMM69AuZPRIM5rpCrUpctRY6z3JMWvgZPzRSH",

			--
			["Bennys - Coffre"] = "https://discord.com/api/webhooks/789971970292318250/m50GtjRBtZKLSPhWSjHMBSAKkga0hFx_6JjP0cwLO0si5j7sDcehPG7WzkBeI55kJi3-",
			["Bennys - Factures"] = "https://discord.com/api/webhooks/789972018879660103/O9qvw63c2LJoZLgfmkr0-IuN94ME_4qDbCyq1x0XeJ-J78F_ismvtxshkzhtbg6E8O2x",
			["Bennys - Customs"] = "https://discord.com/api/webhooks/789972062118346763/oTA4SwE1Ncoe9Ej8OPD3miLk10pF4deGDMic9SdvOT5oQQtbXeg0GRnHYWuspOCBJlGF",
			["Bennys - Service"] = "https://discord.com/api/webhooks/789965011556237323/Bo1gmZpDMKSWPOPyJh_bUJXKZOUgfCCKs5qHicCLz32-3bFLdkeJuAGkpN3CFkIWr30K",

			--
			["Mecano Sandy Shores - Coffre"] = "https://discord.com/api/webhooks/789972112009854996/1cuFx1nz34P_AllFzVOSr7y0-OGzt7MEJdApCnnAE0sAqKkNir8xo-nIJQXDLvvGBXg7",
			["Mecano Sandy Shores - Factures"] = "https://discord.com/api/webhooks/789972157144498187/rP-igu6M49tWrijqErA6ze3AAtAhQTuGcpCZEHUXnBbZ8PNeaOVbe4eLB_VmPwEYDBtQ",
			["Mecano Sandy Shores - Customs"] = "https://discord.com/api/webhooks/789972197787697182/6RkHqO92uih_nrAnn5rg3xaw16Td6cBlQtHCr8ladKrA8hxSSt5qmlpnRMUUZNunjTTf",
			["Mecano Sandy Shores - Service"] = "https://discord.com/api/webhooks/789969251117170718/g7CBQvfbOX7Gozqa9hQ8qLe1XpZOE27Pv617kauO8HOsg8nN5gqMruQ2Fe8yzHrWP2Bn",

			["Mosley - Coffre"] = "https://discord.com/api/webhooks/805555689228861440/dUKx0uCi00WzulXhNRf4hsZdMI3wQkLrMtI2YE9srlwXBc7xdrnFU0sIiaH430RJWXsz",
			["Mosley - Factures"] = "https://discord.com/api/webhooks/805555927537156097/gNY35DgBAQesb3i78hU0xq7-zYIX_mfDLrOij-Tk_1Uh2Mv-RZVwsT3IzcxcJGVj5zV2",
			["Mosley - Vente Véhicules"] = "https://discord.com/api/webhooks/805558013242900501/POm_WU-wZklbyym1eKi0S-Uhbj5LPaS6HgSNFayIW_5ddGHH7ykFbNlS6cIlWpWX-B5w",
			["Mosley - Service"] = "https://discord.com/api/webhooks/805558142166630400/fHjp7G1kBWAFh94UtNrye_n0xGr7jb59KwjkFnhHYA3Xvk4YdhNAHliacffQbpvAlr1u",
			["Mosley - Argent"] = "https://discord.com/api/webhooks/805558066350522368/p5mEr9Z2Fp6APJb74RxZ1E7nJnr5II7u9h3byXBj0RGaX8oQxstkQRK2OvVFAPLZKet9",

			--
			["Galaxy - Coffre"] = "https://discord.com/api/webhooks/805559356354723881/CxyjcEDsfDAC5ppPE6GUCeQHZpQka-aPLI6yVMWfJy5TE01SOR_8yzAOBH9h4godvhYK",
			["Galaxy - Factures"] = "https://discord.com/api/webhooks/805559309135380510/EjleS86RFLpQGcfVOWBhwKS6--gXinqquKZOjr1tphra5_hNrOFlw5oZC_xgs6B6ODCG",
			["Galaxy - Service"] = "https://discord.com/api/webhooks/805559262175559710/5M-EA9b_e3xjziGKiS7n396mx9RP4s99SHiL4I-7JX7MwueZOvhzgv43UIEzUEyIvuYc",

			-- Diner / Black wood 
			["Black Wood - Coffre"] = "https://discord.com/api/webhooks/951571805854892072/xGrOHQ3oCmD3XqFysyEWn-psZ_JPbWMB9KNYbJB_SySIBM1kK5KlwMViO32zfWQKvqKX",
			["Black Wood - Factures"] = "https://discord.com/api/webhooks/951571837517713418/aoMFfiwCN5rUcAOc2I0tcLbMcds_gjNyqhjlVuDGjO_Q6Ql2O2ESjnglv7-yUpx1OJUg",
			["Black Wood - Service"] = "https://discord.com/api/webhooks/951571866668114010/_nJGzHX462SHeqcfqoVeCL9eugLEvqVSp416zoDbq4-pTZ56p8sZ7m4pMO6qIAeU2fkN",
			
			-- Bahama 
			["Bahama - Coffre"] = "https://discord.com/api/webhooks/965973930789715999/lkkv2vgnqgppMT1y0Y1oEwE0GPOl5iABPlrGXfcNJfWoVr7df2GBwJ7SAGzwwBSjaZMb",
			["Bahama - Factures"] = "https://discord.com/api/webhooks/965974033495646229/z0TeqXlzpOkIgOQTSfzjwKOaOiYCk-Q9E5hlS-SYGQ7GIjc5APNjRvMVpTcR31h-zWNN",
			["Bahama - Service"] = "https://discord.com/api/webhooks/965974094564708402/DqcqxHF6p3L1Ea44AHWKNXfQAuiaQXTnY-7oAo31ZXYRVYbzLNyFLgqLcr1QweFL8_eE",

			-- 8 Pool Bar 
			["8 Pool Bar - Coffre"] = "https://discord.com/api/webhooks/956567349543182417/8nwjwsLxaDDnwH_wiOl8bI7nqZlTtpnWJhvZ95mRsveMvy4Lh-juqMLMzALfQgH5B-9y",
			["8 Pool Bar - Factures"] = "https://discord.com/api/webhooks/956567559812026368/NGUMkiXAI_vnKcxJ_-5RYJ4zEfskDx5f6wfPc1N1KKdL7Ut8n_LsD7tVIFE8yQpY7X2k",
			["8 Pool Bar - Service"] = "https://discord.com/api/webhooks/956567670927556648/gqzHB7x58hMju2w9bRmE_4jCSLebHnwSTIMdYo2kYguOeaeE-N3JXO294HagdJtO_AWK",

			-- Bean Machine Coffee
			["Bean Coffee - Coffre"] = "https://discord.com/api/webhooks/969755929610448896/nXvv03hpKIptZ31kVNV-aUq29XTQLBa0xLI51rRchiZkNn9hSZOVJY8bZx1f20vMykO9",
			["Bean Coffee - Factures"] = "https://discord.com/api/webhooks/969756027694243850/V5ZFcf7tRJ0XCey7fConOLXtf24hWtWnM5z43APHv2VsuNB1VV7DSp4h0N9ii0RayELh",
			["Bean Coffee - Service"] = "https://discord.com/api/webhooks/969755971930972210/BCDgMp9K1ov9Ah9BhUrSGL2lmjAawvs4aZWSyoIMWewghOem8SSnWyOkRQuCTUWm48D-",
			
			-- Yellow Jack
			["Yellow Jack - Coffre"] = "https://discord.com/api/webhooks/988620199097950290/M1XoSG0T2JWgQm8S7v0uHEhoDxAPYqnnQkTxCUnYk0zLa8XtRg0dS9BYD79ASumckye5",
			["Yellow Jack - Factures"] = "https://discord.com/api/webhooks/988620285198618704/G_L4JZqoenArmwv_8gcwmUjTYQ5DlEpToHtOTVIDtZyhSy-WwW9rxECf3AvAMm4VtUNv",
			["Yellow Jack - Service"] = "https://discord.com/api/webhooks/988620375338389504/a_5PRYO8AablDjXvKN4Sv-Mcpi7qRhIE4NYTs7R3hIk22fcbtSTvt69KNlYMG9FQdCkJ",
			
			-- Taxi interim
			["Taxi - Set / Unset Job"] = "https://discord.com/api/webhooks/994863647438422107/fs38HJ6bfCTyQt-J7-XbBnw6DfBpfnZK0OV52TPA9-eqPIJ0JmPFbcRMyKNLjRutoZqB",
			["Taxi - Factures"] = "https://discord.com/api/webhooks/994863716220813403/wwXXCEF7PxLcrscP2Cpj3I4Gk50ic_UcDKSVM2eJD8IrKEZk59Werwis-cOZyRwdnUV9",
			["Taxi - Paiement"] = "https://discord.com/api/webhooks/994863786181804063/HzBrXLkzDjoSKL8wo4dTEErpAHIUum7lg7ZBQXzIQEC391bzWJ4HghquoDI_dy6b6M-q",

			-- Hooka Lounge
			["Hookah Lounge - Coffre"] = "https://discord.com/api/webhooks/996823904549081098/fZu_bRafKw1jIVDJ69MxQ47grnRPiEvG8a5jbAEOWy1q-mfU9KU93BdlpFwNw68-Mz7L",
			["Hookah Lounge - Factures"] = "https://discord.com/api/webhooks/996823964267589642/T2ui1N5i3rptA9mZ_YXWjrLFLKvTePFRKJiwhyqtEkIP3XwI13WlZ0RwsEQ8YpPbmAb3",
			["Hookah Lounge - Service"] = "https://discord.com/api/webhooks/996824062246527087/yPlOKwG4aZKc6_1LwN-UBf4Ua4pVS0AuApLJUPl4VXYSHL2SfB-f7-c-edcHurg9uaKd",

			-- Casino
			["Casino - Frigo"] = "https://discord.com/api/webhooks/1001842679677714482/nWobDUeeZ4W6FRsPiK0qbOti7Rew6Yf4uWoSLW5E5pnq4sPEw9k6pPPKd-Z1V3bDJIcW",
			["Casino - Coffre"] = "https://discord.com/api/webhooks/1001838577975570452/SGAXP3Pv3tZgrQn6XoHyd2nvhm_SBExv1AvxrYiG1ibF3EL97eSqvELigNQRjPoablvn",
			["Casino - Coffre Argent"] = "https://discord.com/api/webhooks/1001853212858523749/XVhHWcIy7uDi7XCOTqE1cvW08bWXuEKBpTIjrBG5SgUiRhYYL262fPZRqjf21GpoKe21",
			["Casino - Factures"] = "https://discord.com/api/webhooks/1001838236840239254/EqWQ1qmqoZhhfEDAV7gFcPMqMigFkoeJiJEhwx6dWfFTiQ0C3kFtYJKcQyhSfvmPuVCM",
			["Casino - Service"] = "https://discord.com/api/webhooks/1001838168129146881/-wlEYSxyK-cd547KCLEm7268ohAb3tt9Alt72Jh9u28p05Wm0nEPJ79d58XhySjg-SaX",			
			["Casino - Jeton Propre"] = "https://discord.com/api/webhooks/1001838390683127881/DUezmTtbwbigccWpPu7Z-GKEf1wPGZi8AfhqUETKTsNjp4pjbnzLB8r1ETlQYBThSi7E",			
			["Casino - Jeton Sale"] = "https://discord.com/api/webhooks/1001838449244000327/b89HsY5d7GuIR2XdnmdJGtdrkQrUjGxAmjJcjoVFx7QTXbSnq3oZTdVMKndb297t2w2u",			
			["Casino - Paiement Jeton"] = "https://discord.com/api/webhooks/1001838511294529606/q0O7yPkRENFHWTMW4Xq5wznK1e4gemwQli5i2KDKE98nNo26DiCsVTO18xGk7f8t2rqb",			

			-- Pizza This
			["Pizza This - Coffre"] = "https://discord.com/api/webhooks/1026960311430938684/d3uw7Ak4x_xasvyQ5y7AQLzsM6ANRr4k2lalmniwjLSoNgo-5-0lLnp9ibp7akAD5IV_",
			["Pizza This - Factures"] = "https://discord.com/api/webhooks/1026960358851752027/9S9nINxSTt_YHhLM6PFKbvEPDg5ruTx6LIdxPsufKi9sXBG-U5AAS58Y8Z7cRpdqc90p",
			["Pizza This - Service"] = "https://discord.com/api/webhooks/1026960425348235274/jdXCscVoZMKVbp3MEvr-PwUWs2_tmDoagTVe7An5yEknpqA22n99-YR1F056Is-h8A5P",
			
			-- LSPD
			["LSPD - Coffre"] = "https://discord.com/api/webhooks/805266421772582932/LoYgCAr7S81unZyWYiEdFE6RTtJ5Vr880TFP9ZJvH3lUXiCYYAuZdMxy3gB5TrU1qLC7",
			["LSPD - Armurerie"] = "https://discord.com/api/webhooks/805266470841614347/RpWvb9iJAS6q0CPRjkPrXqRvGzr7zmH1ve0qoEoH8xpnnF5s2qq3sclYRTiLivxfza7r",
			["LSPD - Service"] = "https://discord.com/api/webhooks/805266541775814676/oiuJL4s6skpK83Vr6ssjgxaeK0VpdaYeWQu5yvpEtw9gdDuZGpap0g63ZW9NMqHGKfg5",
			["LSPD - Argent"] = "https://discord.com/api/webhooks/805269191941685279/X_43X6TC0nA2xnbZdDHyfw2u7ap233QmK7c79ld7Sp09wMLYW8DgC9JuUsTP4H9ow71S",
			["LSPD - Amendes"] = "https://discord.com/api/webhooks/805270125812645909/LXIhxAp3W8pMGb-Oral4TfgchJbCpOzHqeoap7ldLXXq4K-jwSisRptYKXSgRiUlBODO",
			["Prise de radar sur agents"] = "https://discord.com/api/webhooks/793883719508557825/pATEh8fMysoo4Vho4XHpNUbR1PAy6BecHAO2kfDksB-OS4L1DV2dsWnORMIyN1ngXZeh",
			["Prise de radar"] = "https://discord.com/api/webhooks/793883763201015888/d8cZt9tI180uF3AAmghvX3zR1azJwainRCCV98lI-kJv0XbJBOhLNTlwdoEXMeSWiW3F",
			["Suivi bracelet electronique"] = "https://discord.com/api/webhooks/903644199159750669/S7rP5s3-FKXoYv0GjV1Zc9_13XsdnEOqkcRkj1IPhHYB3mBkQuesl39oL9NiqTqZE5Qw",
			["LSPD - Usage Gilet"] = "https://discord.com/api/webhooks/959964216188600400/Kk61IuU8_JoSTyx1DO6sBTvsMGuAPEXVxsTmZM_iIseIT5QL5IWH8kktAeVwRq4Mko3D",
			
			["POLICE - Papiers"] = "https://discord.com/api/webhooks/805266506950377512/36ejZMOs5NMyaExaokJ55w8X3BnpfIC3hUBSLdPs5-X_0Z7gwWoUjpWRYE-vLUIYAcgB",

			-- Shériffs
			["Sheriff - Coffre"] = "https://discord.com/api/webhooks/805266935549132801/Tq2HfGC-DyEoclOxxsrpk9L1-5YEjjFTakSMPDf8rqQ9tmgAHCs5uF-PyK6z28cEmLSx",
			["Sheriff - Armurerie"] = "https://discord.com/api/webhooks/805266977891418152/Tob_TU_rTCLr1PEPXsd2yGLceCo8zXDPFaAYGjLt-CS5ds8aHP8Kzqu-IiVn-w-Dy3Ts",
			["Sheriff - Service"] = "https://discord.com/api/webhooks/805267073180762132/N3tjl3EBTjFbZlYGA3UgvGIu21jDiD-7qCxcVO6ieAecg6xdhoICy7qbhM5fXU-u_74e",
			["Sheriff - Argent"] = "https://discord.com/api/webhooks/805272334679670794/ayqPmDUCiQOV40UoTJ9Nbx1ixat3RRKnaXaG_M_rcD5Dacqp1hwHJcBKkD4ikx3CovHO",
			["Sheriff - Amendes"] = "https://discord.com/api/webhooks/805274319143043073/Etu3vuJqDzmkFIVL8lINvHV0QTqCcrT5NxQ7sQbxE_bgixqwviytSPVQdK9ey5kCYj1r",
			["Sheriff - Papiers"] = "https://discord.com/api/webhooks/805267016797257748/UwoOk3Emq9hbVmn7v3AytaMfaSeR4CBQtrGPm09SfkDXO5_1SRmMmZT5giFiRtAKYf_J",
		
			-- DEFAULT LOG 
			["Default - Coffre"] = 'https://discord.com/api/webhooks/1045829169642229930/_0OpcFB8yyuF40ldmus1QF1krw2V2vWaWSZu-4IS9W24I63RI-xlEc48tNLE91dScGPq',
			["Default - Armurerie"] = 'https://discord.com/api/webhooks/1045829452078252123/u9-xUtbj68KY_Gy7nYs_4eW2GXK64yymy5zIktnZd0IzuA3WZ8JsjS86XCBHBffQQtLr',
			["Default - Log Not Track"] = 'https://discord.com/api/webhooks/1045844366490599434/lffZi1x2lO0QIyL9D_FSxDtmzzKO7YECnz9kt6HvGDYGekJ1929qfYVsXy3as6Al75RQ',
			["Default - Objet jeter"] = 'https://discord.com/api/webhooks/1047447390094897202/Eh6ls55JsLzRzi3m14AksWYX9fBOhnfOieocp7y0Mgej6kOFh_k-3RHxxQuuxlc_pNdA',
		}
	}
}

Config.Garage = {
	DayReturnVehicleAssurance = 5
}

Config.VehiclePerm = {
	-- repopulate the map with vehicles that were lost when the server rebooted
	populateOnReboot = true,

	-- save vehicle data on txAdmin scheduled restart
	txAdmin = true,
  
	-- how close a player needs to get to a deleted persistent vehicle before it is respawned
	respawnDistance = 350, -- 350+
  
	-- don't respawn a vehicle that's been destroyed
	forgetOnDestroyed = false,

	PersistPnjVehicle = true,

	ForgetAfterVehicleNPC = 720000,

	LastIdVehicle = 0,
  
	-- time in ms that the server waits before it attempts to spawn vehicles and update their properties/coords. 
	serverTickTime = 2000, -- anything lower than 1000 will cause unnecessary server load. Anything higher than 3000 may cause vehicle popping depending on "respawnDistance"
  
   -- enable debugging to see server console messages; can be toggled with server command: pv-toggle-debugging
	debug = false,
}

Config.WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('GADGET_PARACHUTE'))] = 'Parachute',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battleaxe',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_PIPEWRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_STONE_HATCHET'))] = 'Stone Hatchet',
	[tostring(GetHashKey('WEAPON_KATANA'))] = 'Katana',

	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'Pistol Mk2',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50	',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'SNS Pistol Mk2',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_REVOLVER_MK2'))] = 'Heavy Revolver Mk2',
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Double-Action Revolver',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_RAYPISTOL'))] = 'Up-n-Atomizer',

	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_SMG_MK2'))] = 'SMG Mk2	',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG	',
	[tostring(GetHashKey('WEAPON_COMBATMG_MK2'))] = 'Combat MG Mk2',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_RAYCARBINE'))] = 'Unholy Deathbringer',

	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'Assault Rifle Mk2',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2'))] = 'Carbine Rifle Mk2',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2'))] = 'Special Carbine Mk2',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE_MK2'))] = 'Bullpup Rifle Mk2',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',

	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER_MK2'))] = 'Heavy Sniper Mk2',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE_MK2'))] = 'Marksman Rifle Mk2',

	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WAPAON_PIPEBOMB'))] = 'Pipe Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',

	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RAYMINIGUN'))] = 'Widowmaker',

	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'Pump Shotgun Mk2',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-off Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_SWEEPERSHOTGUN'))] = 'Sweeper Shotgun',

	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'un véhicule',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar'
}