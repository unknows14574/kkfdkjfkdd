local PlayerPed = false
local PlayerPos = false
local PlayerLastPos = 0
local InUse = false
local dist = nil
local currentProp = {}
-- local animationindex = 1

local function Animation(dict, anim, ped)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end

	TaskPlayAnim(ped, dict , anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
end

local function ShowNotification(msg, saveToBrief, hudColorIndex)
	SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    
    if hudColorIndex then
        ThefeedNextPostBackgroundColor(hudColorIndex)
    end
    DrawNotification(true, true)
end

local function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 350
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

local function DrawText2D(text,font,centre,x,y,scale,r,g,b,a)
	oCanSleep = false

	SetTextFont(6)
	SetTextProportional(6)
	SetTextScale(scale/1.0, scale/1.0)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

local function CheckChairOrBed()
    local current = nil
    for i, v in ipairs (SitOnProp.objects.locations) do
        current = v
        local isString = type(current.objName) == "string"        
        local objHash = nil
        
        if isString then
            objHash = GetHashKey(current.objName)
        else
            objHash = current.objName
        end

        local objectselected = GetClosestObjectOfType(PlayerPos, 0.7, objHash, false, false, false)
        if objectselected ~= 0 then
            current.object = objectselected
            break
        else 
            current = 0
        end
    end
    return current
end

local function ActionOnProp(currentSelectedProp,coordsObject,dist)
    PlayerPed = PlayerPedId()
    PlayerPos = GetEntityCoords(PlayerPedId())
    coordsObject = GetEntityCoords(currentSelectedProp.object)
    dist = #(PlayerPos - vector3(coordsObject.x, coordsObject.y, coordsObject.z))
    if dist < 2 then
        if not InUse then
            TriggerEvent('Core:EnterProps', coordsObject)
        end
    end
end

AddEventHandler('Core:SitOnProps',function(cb)
    PlayerPed = PlayerPedId()
    PlayerPos = GetEntityCoords(PlayerPedId())
    PlayerLastPos = PlayerPos
    currentProp = CheckChairOrBed()
    if currentProp ~= 0 then 
        local coordsObject = GetEntityCoords(currentProp.object)
        dist = #(PlayerPos - vector3(coordsObject.x, coordsObject.y, coordsObject.z))
        ActionOnProp(currentProp,coordsObject,dist)
    else
        ShowNotification("Tu ne peut pas t'assoir sur ce props ou tu es trop loin d'un props pour pouvoir t'assoir dessus.")
        ShowNotification("Si tu veux pouvoir t'assoir dessus fait nous un ticket avec un screen du props et ou il est.")
    end
    cb(InUse,currentProp)
end)

RegisterNetEvent('Core:LeaveProps')
AddEventHandler('Core:LeaveProps',function()
    InUse = false

    local x, y, z = table.unpack(PlayerLastPos)
    dist = #(PlayerPos - vector3(x, y, z))
    if dist <= 10 then
        DetachEntity(PlayerPed, true, true)
        ClearPedTasks(PlayerPed)
        ClearPedSecondaryTask(PlayerPed)
        ClearFacialIdleAnimOverride(PlayerPed)
        Wait(1500)
        FreezeEntityPosition(PlayerPed,false)
        SetEntityCoords(PlayerPed, PlayerLastPos)
        PlayerPed = false
        PlayerPos = false
        PlayerLastPos = 0
        currentProp = {}
    end
end)

AddEventHandler('Core:MooveOnProps',function(action)
    -- local type = currentProp.type
    -- local command = SitOnProp.objects.SitAnimationCommandList[animationindex]
    local objectcoords = GetEntityCoords(currentProp.object)
    local ped = PlayerPedId()
    local vertx = currentProp.verticalOffsetX
    local verty = currentProp.verticalOffsetY
    local vertz = currentProp.verticalOffsetZ
    local dir   = GetEntityHeading(ped)

    if action == 'left' then
        dir = dir + 22.5
    elseif action == 'right' then
        dir = dir - 22.5

    end

    -- command = SitOnProp.objects.SitAnimationCommandList[animationindex]

    ClearPedTasksImmediately(ped)
    TaskStartScenarioAtPosition(ped, SitOnProp.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, dir, 0, true, true)

    -- ExecuteCommand(command)
end)

RegisterNetEvent('Core:EnterProps')
AddEventHandler('Core:EnterProps', function(coords)
    local object = currentProp.object
    local vertx = currentProp.verticalOffsetX
    local verty = currentProp.verticalOffsetY
    local vertz = currentProp.verticalOffsetZ
    local dir   = GetEntityHeading(currentProp.object)+currentProp.direction
    local objectcoords = coords
    
    local ped = PlayerPed
    PlayerLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(object, true)
    FreezeEntityPosition(ped, true)
    InUse = true

    if SitOnProp.objects.SitAnimation.dict ~= nil then
        SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
        SetEntityHeading(ped, GetEntityHeading(object) - 90.0)
        local dict = SitOnProp.objects.SitAnimation.dict
        local anim = SitOnProp.objects.SitAnimation.anim
        
        AnimLoadDict(dict, anim, ped)
    else
        TaskStartScenarioAtPosition(ped, SitOnProp.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, dir, 0, true, true)
        AttachEntityToEntity(ped, currentProp.object, 0, vertx, verty, vertz, 0.4, 0.0, dir, 1, 1, 1, 0, 2, 1)
    end

end)