local function GetPlayerPedValid()
    local playerPedValid = {
        [1] = { name = "Dr Dre", model = "ig_ary_02" },
        [2] = { name = "Dr Dre jacket", model = "ig_ary" },
        [3] = { name = "Ashley", model = "u_f_y_lauren" },
        [4] = { name = "Masque Monkey", model = "u_m_m_streetart_01" },
        [5] = { name = "SDF doudoune", model = "u_m_y_proldriver_01" }
    }
    return playerPedValid;
end

local function IsPlayerPedValid()
    local result = false
    local playerPed = PlayerPedId()
    local playerPedValid = GetPlayerPedValid()

    for index, value in ipairs(playerPedValid) do
        local model = GetHashKey(value.model)
        if IsModelValid(model) then
            if not HasModelLoaded(model) then
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
            end
            if IsPedModel(playerPed, value.model) then
                SetModelAsNoLongerNeeded(model)
                result = true
            end
            SetModelAsNoLongerNeeded(model)
        end
    end
    return result
end

local function CanAccessModeration()
	local canAccess = nil
	ESX.TriggerServerCallback('Core:CanAccessModeration', function(result)
		if result then
			if result.canAccess then
				if result.canByPass then
					canAccess = true
				elseif IsPlayerPedValid() then
					canAccess = true
				else
					canAccess = false
				end
			else
				canAccess = false
			end
		else
			canAccess = false		
		end
	end)
	while canAccess == nil do
		Citizen.Wait(10)
	end
	return canAccess
end

exports('GetPlayerPedValid', GetPlayerPedValid)
exports('IsPlayerPedValid', IsPlayerPedValid)
exports('CanAccessModeration', CanAccessModeration)
