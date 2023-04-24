local playerRuns = {}

-- Update number of run / box for a specific user and job (if user has 2 job)
function UpdateUserAndRunValue(userIdentifier, quantity, job)
    local userQuantity = playerRuns[userIdentifier..job]
    if userQuantity then
        playerRuns[userIdentifier..job] = userQuantity + quantity;
    else
        playerRuns[userIdentifier..job] = quantity
    end
end

--[[
    Check if user reached farm limitation

    True : user not reach farm limitation (can continue)
    False : user reach limitation (need to wait server reboot before continue)
]]
function UserReachFarmLimitation(userIdentifier, quantity, job)
    local userQuantity = playerRuns[userIdentifier..job]
    if userQuantity then
        if userQuantity ~= Config.JobNameAndRunLimitation[job] and userQuantity + quantity <= Config.JobNameAndRunLimitation[job] then
            return false
        end
        return true
    end
    return false
end
