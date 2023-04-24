ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/" .. endpoint, function(errorCode, resultData, resultHeaders)
		data = { data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. Config.Discord.DiscordToken})

    while data == nil do
        Citizen.Wait(100)
    end
	
    return data
end

-- Get Discord Role User
function DiscordGetRoles(user)
	local discordId = GetIdentifierForPlayer(user, "discord") or false

	if discordId then
		local member = DiscordRequest("GET", ("guilds/%s/members/%s"):format(Config.Discord.GuildId, discordId), {})
		if member.code == 200 then
			local data = json.decode(member.data)
			return data.roles
		end
	end

	return false
end

--User As Discord Role
function DiscordIsRolePresent(user, role)
	local theRole = nil
	if type(role) == "number" then
		theRole = tostring(role)
	elseif type(role) == "table" then
		theRole = role
	else
		theRole = Config.Discord.Roles[role]
	end

	local discordId = GetIdentifierForPlayer(user, "discord")
	if discordId then
		local member = DiscordRequest("GET", ("guilds/%s/members/%s"):format(Config.Discord.GuildId, discordId), {})
		if member.code == 200 then
			local data = json.decode(member.data)
			for k, v in pairs(data.roles) do
				if type(theRole) == "table" then
					for i = 1, #theRole do
						if Config.Discord.Roles[theRole[i]] == v then
							return true
						end
					end
				elseif v == theRole then
					return true
				end
			end
		end
	end

	return false
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..Config.Discord.GuildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("Permission system guild set to: "..data.name.." ("..data.id..")")
	else
		print("An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
end)


--Get All indentifier Player
function GetIdentifierForPlayer(source, type)
    local identifiers = {}
	
	for _, id in ipairs(GetPlayerIdentifiers(source)) do
		if type and string.find(id, type) then
			return string.gsub(id, type .. ":", "")
		else
			local identifierChoose = Core.Math.StringSplit(id, ":")[1]
			identifiers[identifierChoose] = string.gsub(id, identifierChoose .. ":", "")
		end
	end

    return identifiers
end
--GetIdentifierPlayerForLog
GetIdentifierPlayerForLog = function(id)
	local identifier = GetIdentifierForPlayer(id)
	local player = ESX.GetPlayerFromId(id)
	local MessageEmbed

	if player and player.firstname ~= "" and player.lastname ~= "" then
		MessageEmbed = "\n \n**Prénom RP:** " .. player.firstname .. "\n**Nom RP:** " .. player.lastname .. " \n**Player ID:** " .. id .. "\n**Discord ID:** <@!" .. identifier.discord .. "> \n**Steam ID:** " .. identifier.steam .. "\n**Steam Link:** https://steamcommunity.com/profiles/" .. tonumber(identifier.steam, 16)
	else
		MessageEmbed = "\n \n**Player ID:** " .. id .. "\n**Discord ID:** <@!" .. identifier.discord .. "> \n**Steam ID:** " .. identifier.steam .. "\n**Steam Link:** https://steamcommunity.com/profiles/" .. tonumber(identifier.steam, 16)
	end

	return MessageEmbed
end



--================================================================================================
--==                                Partie Function                                             ==
--================================================================================================

--DiscordWhitelist
function DiscordWhitelist(Deferrals, source)
	local oldDiscordRolWL = "🍂 FiveM"
	local newDiscordRoleWL = "🍂 Whitelist II"
	local DiscodRoleWipe = "🍂 Wipe/Autre"
	
    Deferrals.defer()
	Deferrals.update("Hum... Vérifions si tu as la permission de te connecter sur Nebula")

	if GetIdentifierForPlayer(source, "discord") then
		local asOldRole = DiscordIsRolePresent(source, oldDiscordRolWL)
		local asNewRole = DiscordIsRolePresent(source, newDiscordRoleWL)
		local asWipeRole = DiscordIsRolePresent(source, DiscodRoleWipe)
		if (asOldRole and asNewRole) or asNewRole then
			Deferrals.done()
			return
		elseif (asOldRole and not asNewRole) then
			Deferrals.done("\nTu as l'ancien rôle whitelist. Ouvres un ticket en envoyant un message à @🌌 Support Nebula 🚀#2319 pour demander la procedure de wipe. Tout se passe sur le discord : discord.gg/nebularp")
		elseif (asWipeRole) then
			Deferrals.done("\nTu es au cours d'un procedure de wipe. Envois un message à @🌌 Support Nebula 🚀#2319 afin d'avertir le staff pour qu'il puisse te guider dans la procédure à suivre.")
		else
			Deferrals.done("\nTu n'as pas les droits necessaires pour te connecter. Pour te faire Whitelist, rejoint le discord : discord.gg/nebularp")
		end
	end

    Deferrals.done("\nIl semblerais que ton discord ne soit pas lancé. Vérifie cela ou ouvres un ticket en envoyant un message à @🌌 Support Nebula 🚀#2319 !")
end

--SetActivityDiscord
function SetActivityDiscord()
	local GetAllPlayers = GetPlayers()
	for k, v in pairs(GetAllPlayers) do
		TriggerClientEvent("Discord:SetActivity", v, #GetAllPlayers)
	end
end

--Send Log Discord
function SendDiscordLog(ChannelName, Message, Color)
	if Config.Discord.Log.Active then
		local embed = {
			username = "Nebula Log", 
			embeds = {
				{
					["color"] = (Config.Discord.Log.IsDev and Config.Discord.Log.Color.Blue_Dev) or ((Color ~= nil and Config.Discord.Log.Color[Color] ~= nil) and Config.Discord.Log.Color[Color]) or Config.Discord.Log.Color.Red, 
					["author"] = {
						["name"] = ChannelName,
						["icon_url"] = "https://i.imgur.com/ZWuscbu.png"
					}, 
					["description"] = ((Config.Discord.Log.IsDev and ("`[SERVEUR DEV]` "..Message)) or (Message ~= nil and Message)) or (Message ~= nil and Message) or "",
					["footer"] = {
						["text"] = os.date("%d/%m/%Y %X"), -- Heure format Français.
						["icon_url"] = "https://i.imgur.com/ZWuscbu.png"
					},
				}
			}, 
			avatar_url = "https://i.imgur.com/ZWuscbu.png"
		}
		PerformHttpRequest(Config.Discord.Log.WebHook[ChannelName], function(err, text, headers) end, 'POST', json.encode(embed), { ['Content-Type'] = 'application/json' })
	end
end

--================================================================================================
--==                                Partie Event                                             ==
--================================================================================================

-- Serveur start, notification : 
AddEventHandler('onResourceStart', function(resourceName)
	if not Config.Discord.Log.IsDev and GetCurrentResourceName() == resourceName then -- N'affichera pas la log si c'est un serveur dev déclaré dans le server.cfg. 
		SendDiscordLog('Le serveur a redémarré!',"Lien de connexion direct: <fivem://connect/wl.nebularp.com>", 'Yellow')
	end
end)

-- SendDiscordLog
RegisterServerEvent('CoreLog:SendDiscordLog')
AddEventHandler('CoreLog:SendDiscordLog', function(ChannelName, Message, Color, SecondPlayer, FirstPlayer)
	SendDiscordLog(ChannelName, Message .. (FirstPlayer and FirstPlayer ~= nil and FirstPlayer ~= false and GetIdentifierPlayerForLog(((FirstPlayer and FirstPlayer) or source)) or "") .. ((SecondPlayer and SecondPlayer ~= nil and SecondPlayer ~= false and GetIdentifierPlayerForLog(SecondPlayer)) or ""), Color)
end)