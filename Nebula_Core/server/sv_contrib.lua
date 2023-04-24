-- Function Player
local function GetPlayerId(identifier)
    local result = nil
    TriggerEvent('esx_jobcounter:returnTableMetierServer', function(TableUser)
        for k, v in pairs(TableUser) do
            if identifier == v.identifier then
                result = v.id
            end
        end
    end, "tabName", "players")
    return result
end

-- Give Item
local function GiveItemContrib(_, arg)
    local IdServ = arg[1]
    local item = arg[2]
    local PackageName = ""
    
    local xPlayer = ESX.GetPlayerFromId(IdServ)
    if xPlayer.getInventoryItem(item) ~= nil then
        xPlayer.addInventoryItem(item, 1)

        for i=1, #arg do
            if i ~= 1 and i ~= 2 then
                PackageName = (PackageName .. " " .. tostring(arg[i]))
            end
        end

        print("Achat " .. IdServ .. " " .. item .. PackageName)
        
        TriggerEvent('bot:giveitemContrib', IdServ, PackageName)
    end
end
RegisterCommand("giveitemcontrib", GiveItemContrib, true)

-- Sim Custom 
ESX.RegisterUsableItem('custom_sim', function(source)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('custom_sim', 1)
    
	TriggerClientEvent('Nebula_Core:CreateSimContrib', _source)
end)

-- Plaque Custom 
ESX.RegisterUsableItem('custom_plaque', function(source)
    TriggerClientEvent('Nebula_Core:ChangePlateCustom', source)
end)


-- Skin Custom
local SkinArme = {
    ["WEAPON_PISTOL"] = { "first_or" },

    ["WEAPON_COMBATPISTOL"] = { "first_or" },

    ["WEAPON_PISTOL50"] = { "first_or" },

    ["WEAPON_APPISTOL"] = { "first_platine" },

    ["WEAPON_REVOLVER"] = { 
        "first_platine",
        "first_or"
    },
        
    ["WEAPON_SNSPISTOL"] = { "first_bronze" },

    ["WEAPON_HEAVYPISTOL"] = { "first_platine" },

    ["weapon_revolver_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["weapon_snspistol_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital",

        "second_patriot",
        "second_boom",
        "second_geometric",
        "second_zebra",
        "second_leopard",
        "second_perseus",
        "second_sessanta",
        "second_skull",
        "second_woodland",
        "second_brushstroke",
        "second_digital"
    },

    ["weapon_pistol_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital",

        "second_patriot",
        "second_boom",
        "second_geometric",
        "second_zebra",
        "second_leopard",
        "second_perseus",
        "second_sessanta",
        "second_skull",
        "second_woodland",
        "second_brushstroke",
        "second_digital"
    },

    ["WEAPON_MICROSMG"] = { 
        "first_or"
    },
    
    ["WEAPON_SMG"] = { 
        "first_or"
    },
    
    ["WEAPON_ASSAULTSMG"] = { 
        "first_or" 
    },

    ["weapon_smg_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["WEAPON_PUMPSHOTGUN"] = { 
        "first_or"
    },

    ["weapon_sawnoffshotgun"] = { 
        "first_or"
    },

    ["weapon_pumpshotgun_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["WEAPON_ASSAULTRIFLE"] = { 
        "first_or"
    },

    ["WEAPON_CARBINERIFLE"] = { 
        "first_or"
    },

    ["WEAPON_ADVANCEDRIFLE"] = { 
        "first_or"
    },

    ["WEAPON_SPECIALCARBINE"] = { 
        "first_or"
    },

    ["WEAPON_BULLPUPSHOTGUN"] = { 
        "first_or"
    },

    ["weapon_bullpuprifle_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["weapon_specialcarbine_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["weapon_assaultrifle_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["weapon_carbinerifle_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["weapon_mg"] = { 
        "first_or"
    },

    ["weapon_combatmg"] = { 
        "first_or"
    },

    ["weapon_combatmg_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },

    ["WEAPON_SNIPERRIFLE"] = { 
        "first_or"
    },

	["weapon_heavysniper_mk2"] = { 
		"first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
	},

    ["WEAPON_MARKSMANRIFLE"] = { 
        "first_or"
    },

    ["weapon_marksmanrifle_mk2"] = { 
        "first_patriot",
        "first_boom",
        "first_geometric",
        "first_zebra",
        "first_leopard",
        "first_perseus",
        "first_sessanta",
        "first_skull",
        "first_woodland",
        "first_brushstroke",
        "first_digital"
    },
    
}

-- function Split(inputstr, sep)
--     if sep == nil then
--         sep = "%s"
--     end
--     local t={}
--     for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--         table.insert(t, str)
--     end
--     return t
-- end

-- for k, v in pairs(SkinArme) do
--     for l, m in pairs(v) do
--         local name = "skin_weapon_" .. m .. "_" .. GetHashKey(k)
--         local Splitname = Split(k, "_")
--         local nameUse = "Skin " .. Split(m, "_")[1] .. " " .. Split(m, "_")[2] .. " " .. Splitname[#Splitname - 1] .. " " .. Splitname[#Splitname]
--         MySQL.update(
--         'INSERT INTO items (name, label) VALUES (@name, @label)',
--         {
--             ['@name']   = name,
--             ['@label']   = nameUse,
--         },
--         function (rowsChanged)
--             print(name)
--         end)
--     end
-- end

-- RegisterCommand("giveallskin", function(source, args, raw)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     for k, v in pairs(SkinArme) do
--         for l, m in pairs(v) do
--             local name = "skin_weapon_" .. m .. "_" .. k

--             if xPlayer.getInventoryItem(name) ~= nil then
--                 xPlayer.addInventoryItem(name, 1)
--             end
--         end
--     end
-- end)





local function GiveSkinWeapon(_, arg)
    local IdServ = arg[1]
    local item = arg[2]
    local identifier = GetPlayerIdentifier(IdServ)

    MySQL.query(
	'SELECT * FROM skin_weapon_user WHERE identifier = @identifier',
	{
		['@identifier'] = identifier
	},
	function(result)
        if #result >= 1 then
            local JsonDecode = json.decode(result[1].weapon)
            table.insert(JsonDecode, item)
            local JsonEncode = json.encode(JsonDecode)
			MySQL.update(
			'UPDATE skin_weapon_user SET weapon = @weapon WHERE identifier = @identifier',
			{
				['@weapon'] = JsonEncode,
				['@identifier'] = identifier
            })
        else
            local JsonEncode = json.encode({item})
            MySQL.update(
            'INSERT INTO skin_weapon_user (identifier, weapon) VALUES (@identifier, @weapon)',
            {
                ['@identifier'] = identifier,
                ['@weapon'] = JsonEncode
            })
        end

        local xPlayer = ESX.GetPlayerFromId(IdServ)
        local itemPlayer = xPlayer.getInventoryItem("skin_weapon_menu")
        if itemPlayer ~= nil and itemPlayer.count < 1 then
            xPlayer.addInventoryItem("skin_weapon_menu", 1)
        end
        
        local PackageName = ""
        for i=1, #arg do
            if i ~= 1 and i ~= 2 then
                PackageName = (PackageName .. " " .. tostring(arg[i]))
            end
        end

        print("Achat " .. IdServ .. " " .. item .. PackageName)
        
        TriggerEvent('bot:giveitemContrib', IdServ, PackageName)
	end)
end
RegisterCommand("giveskinweapon", GiveSkinWeapon, true)

ESX.RegisterUsableItem("skin_weapon_menu", function(source)
    local ResultWeapon = MySQL.query.await("SELECT skin_weapon_user.weapon FROM skin_weapon_user WHERE identifier = @identifier", {
        ['@identifier'] = GetPlayerIdentifier(source)
    })
    if #ResultWeapon >= 1 then
        TriggerClientEvent('Nebula_Core:SkinArmeMenu', source, ResultWeapon[1])
    else
        TriggerClientEvent('Core:ShowNotification', source, "Tu ne peux pas utiliser ceci")
    end
end)




-- Skin Arme
-- MySQL.query("SELECT items.name FROM items", {}, function(TableSkinWeapon)
--     for k, result in pairs(TableSkinWeapon) do
--         if string.match(result.name, "skin_weapon_") ~= nil then
--             ESX.RegisterUsableItem(result.name, function(source)
--                 local SplitName = Core.Math.StringSplit(result.name, "_")
--                 TriggerClientEvent('Nebula_Core:SkinArme', source, false, SplitName[#SplitName], SplitName[#SplitName - 1], SplitName[#SplitName - 2])
--             end)
--         else string.match(result.name, "allskinweapon_") ~= nil then
--             ESX.RegisterUsableItem(result.name, function(source)
--                 local SplitName = Core.Math.StringSplit(result.name, "_")
--                 TriggerClientEvent('Nebula_Core:SkinArme', source, true, false, SplitName[#SplitName], "first")
--             end)
--         end
--     end
-- end)