ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local default = {
    matchInProgress = false,
    currentPlayers = {},
    queue = {timer = false},
    matchEnds = false,
    prizePool = 0
}

local defaultDefault = {
    matchInProgress = false,
    currentPlayers = {},
    queue = {timer = false},
    matchEnds = false,
    prizePool = 0
}

local teams = {
    {name = 'Team A', players = {}},
    {name = 'Team B', players = {}}
  }
  
  function AddPlayerToTeam(playerId)
    -- Trouver l'équipe avec le moins de joueurs
    local minTeam = teams[1]
    for _, team in ipairs(teams) do
      if #team.players < #minTeam.players then
        minTeam = team
      end
    end


  
    -- Ajouter le joueur à l'équipe
    table.insert(minTeam.players, playerId)
  
    -- Envoyer un message au joueur pour lui indiquer dans quelle équipe il se trouve
    TriggerClientEvent('chat:addMessage', playerId, {
      color = {255, 0, 0},
      multiline = true,
      args = {'Serveur', 'Vous êtes dans l\'équipe ' .. minTeam.name}
    })
  end
  
  RegisterCommand('team_mode', function(source, args)
    -- Code pour permettre aux joueurs de choisir entre le mode solo et le mode en équipe
  end, false)

  AddEventHandler('playerDropped', function(reason)
    -- Retirer le joueur de son équipe
    for _, team in ipairs(teams) do
      if table.contains(team.players, source) then
        table.remove(team.players, table.index_of(team.players, source))
        break
      end
    end
  end)
  
  AddEventHandler('onPlayerDeath', function(killerId, deathData)
    if teamMode then
      -- Ajouter un point à l'équipe du joueur qui a tué le joueur mort
      AddScoreToTeam(killerId, 1)
    end
  
    -- Attendre 5 secondes avant de faire respawn le joueur mort
    Citizen.Wait(5000)
  
    -- Faire respawn le joueur mort
    local spawnPoint = GetRandomSpawnPoint()
    TriggerClientEvent('esx_paintball:spawnPlayer', source, spawnPoint.x, spawnPoint.y, spawnPoint.z)
  end)


  
  function UpdateTeamScore(teamName, score)
    MySQL.Async.execute('UPDATE paintball_team_scores SET score = @score WHERE name = @name', {
      ['@name'] = teamName,
      ['@score'] = score
    }, function(rowsChanged)
      if rowsChanged == 0 then
        MySQL.Async.execute('INSERT INTO paintball_team_scores (name, score) VALUES (@name, @score)', {
          ['@name'] = teamName,
          ['@score'] = score
        })
      end
    end)
  end
  
  function GetTeamScores(callback)
    MySQL.Async.fetchAll('SELECT name, score FROM paintball_team_scores', {}, function(results)
      local scores = {}
      for _, row in ipairs(results) do
        table.insert(scores, {
          name = row.name,
          score = row.score
        })
      end
      callback(scores)
    end)
  end
  

isplayerActive = function(id)
    local playerTable = GetPlayers()
    for k, v in pairs(playerTable) do
        if tonumber(v) == id then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        for i = 1, #default.currentPlayers do -- in case 'playerDropped' doesn't work
            if default.currentPlayers[i] then
                if not isplayerActive(default.currentPlayers[i].id) then
                    print(default.currentPlayers[i].id) 
                    table.remove(default.currentPlayers, i)
                end
            end
        end
        if default.matchInProgress then
            if #default.currentPlayers < Config.RequiredPlayers then -- if there are not enough players online, cancel the current match
                for i = 1, #default.currentPlayers do
                    TriggerClientEvent('loaf_paintball:stop', default.currentPlayers[i].id)
                    default = json.decode(json.encode(defaultDefault))
                end
                default.currentPlayers = {}
            end
        end
        Wait(2500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not default.matchInProgress then
            if #default.currentPlayers >= Config.RequiredPlayers then
                if not default.queue.timer then
                    local queuetime = 60 * Config.QueueTime
                    default.queue.timer = os.time() + queuetime
                end
                if default.queue.timer - os.time() <= 0 then
                    default.queue.timer = false
                    default.matchInProgress = true
                    local matchends = 60 * Config.MatchLength
                    default.matchEnds = os.time() + matchends
                    for i = 1, #default.currentPlayers do
                        local xPlayer = ESX.GetPlayerFromId(default.currentPlayers[i].id)
                        xPlayer.removeMoney(Config.Price)
                        default.prizePool = default.prizePool + Config.Price
                        TriggerClientEvent('loaf_paintball:start', default.currentPlayers[i].id)
                    end
                end
            end
        end
        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        local text = ''
        local other = ''
        if not default.matchInProgress then
            if #default.currentPlayers >= 1 then
                text = #default.currentPlayers .. Config.Translations['in_queue']
                if default.queue.timer then
                    text = text .. Config.Translations['seconds_starts'] .. default.queue.timer - os.time()
                end
            end
            if #default.currentPlayers < Config.RequiredPlayers then
                default.queue.timer = false
            end
        else
            text = Config.Translations['match_progress']
            other = default.matchEnds - os.time()
            if default.matchEnds - os.time() <= Config.DisplayWinner then
                local killsTable = {}
                for i = 1, #default.currentPlayers do
                    killsTable[tostring(default.currentPlayers[i].id)] = default.currentPlayers[i].kills
                end
                local winner = tonumber(getMax(killsTable))
                local xPlayer = ESX.GetPlayerFromId(winner)
                xPlayer.addMoney(default.prizePool)

                for i = 1, #default.currentPlayers do
                    if default.currentPlayers[i].id == winner then
                        winner = default.currentPlayers[i]
                    end
                end
                for i = 1, #default.currentPlayers do
                    TriggerClientEvent('loaf_paintball:matchOver', default.currentPlayers[i].id, json.encode(winner), json.encode(default.currentPlayers[i]))
                end
                default = json.decode(json.encode(defaultDefault))
                Wait(Config.DisplayWinner * 1000)
                default.matchInProgress = false
            end
        end
        TriggerClientEvent('loaf_paintball:queueInfo', -1, text, other)
        Wait(500)
    end
end)

RegisterServerEvent('loaf_paintball:join')
AddEventHandler('loaf_paintball:join', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getMoney() >= Config.Price then
        if not default.matchInProgress then
            local init = false
            for i = 1, #default.currentPlayers do
                if default.currentPlayers[i] then
                    if default.currentPlayers[i].id == src then
                        init = true
                        table.remove(default.currentPlayers, i)
                    end
                end
            end
            if not init then
                table.insert(default.currentPlayers, {id = src, kills = 0, deaths = 0})
            end
        end
    else
        TriggerClientEvent('loaf_paintball:hudNotify', src, Config.Translations['no_money'])
    end
end)

RegisterServerEvent('loaf_paintball:kill')
AddEventHandler('loaf_paintball:kill', function(killed)
    local src = source
    if default.matchInProgress then
        local killedPlaying = false
        if isplayerActive(killed) then
            for i = 1, #default.currentPlayers do
                if default.currentPlayers[i].id == killed then
                    killedPlaying = true
                    default.currentPlayers[i].deaths = default.currentPlayers[i].deaths + 1
                    TriggerClientEvent('loaf_paintball:die', default.currentPlayers[i].id)
                end
            end
        end
        if killedPlaying then
            for i = 1, #default.currentPlayers do
                if default.currentPlayers[i].id == src then
                    default.currentPlayers[i].kills = default.currentPlayers[i].kills + 1
                    TriggerClientEvent('loaf_paintball:hudNotify', default.currentPlayers[i].id, Config.Translations['you_killed'] .. ': ~r~' .. GetPlayerName(killed))
                elseif default.currentPlayers[i].id == killed then
                    TriggerClientEvent('loaf_paintball:hudNotify', default.currentPlayers[i].id, Config.Translations['you_got_killed'] .. ': ~r~' .. GetPlayerName(src))
                    TriggerClientEvent('loaf_paintball:died', default.currentPlayers[i].id, src)
                else
                    TriggerClientEvent('loaf_paintball:hudNotify', default.currentPlayers[i].id, GetPlayerName(killed) .. Config.Translations['killed_by'] .. GetPlayerName(src))
                end
            end
        end
    end
end)

getMax = function(data)
    local max_val, key = -math.huge
    for k, v in pairs(data) do
        if v > max_val then
            max_val, key = v, k
        end
    end
    return key
end