local noclipActive = false -- [[Wouldn't touch this.]]
local noclip = nil
local index = 1 -- [[Used to determine the index of the speeds table.]]

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

local function CanAccessModeration()
	return exports['Nebula_Core']:CanAccessModeration()	
end

local config2 = {
    controls = {
        -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
        openKey = 312, -- [[^]]
		openKeyShowname = 84, -- [[-/ touche pour radio precedente dans les voitures]]
        goUp = 329, -- [[right clic]] --goUp = 85, -- [[Q]]
        goDown = 330, -- [[left clic]] --goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32,  -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
    },

    speeds = {
        -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
		{ label = "Vitesse minimum", speed = 0.1},
        { label = "Très lent", speed = 0.5},
        { label = "Lent", speed = 1.0},
        { label = "Normal", speed = 1.5},
        { label = "Rapide", speed = 3},
		{ label = "Très rapide", speed = 6},
        { label = "Super rapide", speed = 10},
        { label = "Beaucoup trop rapide", speed = 20},
        { label = "Vitesse max", speed = 50}
    },

    offsets = {
        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
        h = 3, -- [[How much you rotate. ]]
    },

    -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}
local noClipEntity = nil

local function ActiveNoClip()
    ESX.TriggerServerCallback('es_extended:custom:getGroup', function(group)
        while group == nil do
            Citizen.Wait(50);
        end

        if (group ~= "user" and group ~= "mod" and CanAccessModeration()) then
            noclip = not noclip
            noclipActive = not noclipActive
    
            if (group ~= "user" and group ~= "mod" and CanAccessModeration()) then
                TriggerServerEvent('CoreLog:SendDiscordLog', 'NoClip', GetPlayerName(PlayerId()) .. " a "..(noclipActive and "**utilisé** le NoClip" or "**arrêté** d'utiliser le NoClip."), (noclipActive and 'Green' or 'Red'))
            end
            if IsPedInAnyVehicle(PlayerPedId(), false) or IsPedSittingInAnyVehicle(PlayerPedId())then
                noClipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                noClipEntity = PlayerPedId()
            end
    
            SetEntityCollision(noClipEntity, not noclipActive, not noclipActive)
            FreezeEntityPosition(noClipEntity, noclipActive)
            SetEntityInvincible(noClipEntity, noclipActive)
            SetVehicleRadioEnabled(noClipEntity, not noclipActive) -- [[Stop radio from appearing when going upwards.]]
			SetEveryoneIgnorePlayer(noClipEntity, noclipActive)
            NetworkSetEntityInvisibleToNetwork(noClipEntity, noclipActive)
            if noclipActive then
                SetEntityVisible(noClipEntity, false, false);
                SetEntityAlpha(noClipEntity, 51, false)
            else
                SetEntityVisible(noClipEntity, true, false);
                ResetEntityAlpha(noClipEntity)
            end
        end
    end)
end

RegisterNetEvent('es_extended:custom:noClip')
AddEventHandler('es_extended:custom:noClip', function()
	ActiveNoClip()
end)

Citizen.CreateThread(function()

    buttons = setupScaleform("instructional_buttons")

    currentSpeed = config2.speeds[index].speed

    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(1, config2.controls.openKey) then
			ActiveNoClip()
		end

		if IsControlJustPressed(1, config2.controls.openKeyShowname) then
			if (group ~= "user" and group ~= "mod" and CanAccessModeration()) then
				TriggerEvent('xPiwel_showname', true)
			end
		end
		
        if noclipActive then
			SetEntityVisible(noClipEntity, false, false);
			SetEntityAlpha(noClipEntity, 51, false)
			SetLocalPlayerVisibleLocally(true)
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			--DisableControlAction(1, 23, true)
			DisablePlayerFiring(playerPed, true) 
		
            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, config2.controls.changeSpeed) then
                if index ~= #config2.speeds then
                    index = index+1
                    currentSpeed = config2.speeds[index].speed
                else
                    currentSpeed = config2.speeds[1].speed
                    index = 1
                end
                setupScaleform("instructional_buttons")
            end

			if IsControlPressed(0, config2.controls.goForward) then
                yoff = config2.offsets.y
			end
			
            if IsControlPressed(0, config2.controls.goBackward) then
                yoff = -config2.offsets.y
			end
			
            if IsControlPressed(0, config2.controls.turnLeft) then
                SetEntityHeading(noClipEntity, GetEntityHeading(noClipEntity)+config2.offsets.h)
			end
			
            if IsControlPressed(0, config2.controls.turnRight) then
                SetEntityHeading(noClipEntity, GetEntityHeading(noClipEntity)-config2.offsets.h)
			end
			
            if IsControlPressed(0, config2.controls.goUp) then
                zoff = config2.offsets.z
			end
			
            if IsControlPressed(0, config2.controls.goDown) then
                zoff = -config2.offsets.z
			end
			
            local heading = GetEntityHeading(noClipEntity)
            SetEntityVelocity(noClipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noClipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noClipEntity, heading)
            SetEntityCoordsNoOffset(noClipEntity, GetOffsetFromEntityInWorldCoords(noClipEntity, 0.0, yoff * (currentSpeed), zoff * (currentSpeed)), noclipActive, noclipActive, noclipActive)
		end
    end
end)

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(2, config2.controls.openKey, true))
    ButtonMessage("Désactiver NoClip")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config2.controls.goUp, true))
    ButtonMessage("Monter")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config2.controls.goDown, true))
    ButtonMessage("Descendre")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config2.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config2.controls.turnLeft, true))
    ButtonMessage("Tourner Gauche/Droite")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config2.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config2.controls.goForward, true))
    ButtonMessage("Aller en avant/arriere")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config2.controls.changeSpeed, true))
    ButtonMessage("Vitesse ("..config2.speeds[index].label..")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config2.bgR)
    PushScaleformMovieFunctionParameterInt(config2.bgG)
    PushScaleformMovieFunctionParameterInt(config2.bgB)
    PushScaleformMovieFunctionParameterInt(config2.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end