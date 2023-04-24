>> OPTI CODE TO INTEGRATION WITH NEB CORE
>> Sync when a player sits on a chair


>> Add option to rotate when on props
>> Add option to moove right and left when on props
>> Add option to change animation of sitting when on props

>> Add command instruction to every of these option

>> Fichier de backup de fonction pour plus tard peut etre 


>> L.200 
```lua
if type == 'chair' then
    print('chair')
    if animationindex == 2 then
        vertx = vertx - 0.7
        vertz = vertz + 0.5
    elseif animationindex == 3 then
        vertx = vertx - 0.8
        verty = verty + 0.2
        vertz = vertz + 0.5
    elseif animationindex == 4 then
        vertx = vertx - 0.5
        vertz = vertz + 0.5
    elseif animationindex == 5 then
        vertx = vertx - 0.9
        vertz = vertz + 0.5
    elseif animationindex == 6 then
        vertx = vertx - 0.9
        vertz = vertz + 0.6
    elseif animationindex == 7 then
        vertx = vertx - 0.8
        vertz = vertz + 0.5
    end
elseif type == 'chair2' then
    if animationindex == 2 then
        vertx = vertx + 0.3
        verty = verty + 0.6
        vertz = vertz + 0.5
    elseif animationindex == 3 then
        vertx = vertx + 0.6
        verty = verty + 0.6
        vertz = vertz + 0.5
    elseif animationindex == 4 then
        vertx = vertx + 0.2
        verty = verty + 0.4
        vertz = vertz + 0.5
    elseif animationindex == 5 then
        vertx = vertx + 0.4
        verty = verty + 0.8
        vertz = vertz + 0.5
    elseif animationindex == 6 then
        vertx = vertx + 0.4
        verty = verty + 0.8
        vertz = vertz + 0.6
    elseif animationindex == 7 then
        vertx = vertx + 0.4
        verty = verty + 0.6
        vertz = vertz + 0.5
    end
elseif type == 'chair3' then
    if animationindex == 2 then
        verty = verty + 0.6
        vertz = vertz + 0.5
    elseif animationindex == 3 then
        verty = verty + 0.8
        vertz = vertz + 0.5
    elseif animationindex == 4 then
        verty = verty + 0.4
        vertz = vertz + 0.5
    elseif animationindex == 5 then
        verty = verty + 0.8
        vertz = vertz + 0.5
    elseif animationindex == 6 then
        verty = verty + 0.8
        vertz = vertz + 0.6
    elseif animationindex == 7 then
        verty = verty + 0.6
        vertz = vertz + 0.5
    end
elseif type == 'bench' then
    print('bench')
    if animationindex == 2 then
        vertx = vertx + 0.7
        vertz = vertz + 0.5
    elseif animationindex == 3 then
        vertx = vertx + 0.8
        verty = verty - 0.2
        vertz = vertz + 0.5
    elseif animationindex == 4 then
        vertx = vertx + 0.5
        vertz = vertz + 0.5
    elseif animationindex == 5 then
        vertx = vertx + 0.9
        vertz = vertz + 0.5
    elseif animationindex == 6 then
        vertx = vertx + 0.9
        vertz = vertz + 0.6
    elseif animationindex == 7 then
        vertx = vertx + 0.8
        vertz = vertz + 0.5
    end
end

```
>> L.166 
```lua
if type ~= 'chair' and type ~= 'chair2' and type ~= 'chair3' then
    if action == 'up' then
        currentProp.verticalOffsetY = currentProp.verticalOffsetY + 0.5
    elseif action == 'down' then
        currentProp.verticalOffsetY = currentProp.verticalOffsetY - 0.5
    end
elseif type == 'chair' then
    if action =='up' or action == 'down' then
        ShowNotification('Tu ne peut pas te déplacer sur ce props')
    end
end
```

>> L.178

```lua
if currentProp.verticalOffsetY <= 1.0 and currentProp.verticalOffsetY >= -1.0 then
else
    if action == 'up' then
        currentProp.verticalOffsetY = 1.0
    elseif action =='down' then
        currentProp.verticalOffsetY = -1.0
    end
end

vertx = currentProp.verticalOffsetX
verty = currentProp.verticalOffsetY
vertz = -currentProp.verticalOffsetZ
```

>> L.171
```lua
elseif action == 'emote' then
    if animationindex < #Config.objects.SitAnimationCommandList then
        animationindex = animationindex + 1
    else
        animationindex = 1
    end
end
```

>> L.194
```lua 
    if type == 'chair' then

    else
        if Anim == 'back' then
            if Config.objects.BedBackAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 90.0)
                local dict = Config.objects.BedBackAnimation.dict
                local anim = Config.objects.BedBackAnimation.anim
                
                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.BedBackAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true
            )
            end
        elseif Anim == 'stomach' then
            if Config.objects.BedStomachAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 90.0)
                local dict = Config.objects.BedStomachAnimation.dict
                local anim = Config.objects.BedStomachAnimation.anim
                
                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
            end
        elseif Anim == 'sit' then
            if Config.objects.BedSitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 90.0)
                local dict = Config.objects.BedSitAnimation.dict
                local anim = Config.objects.BedSitAnimation.anim
                
                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
            end
        end
    end
```