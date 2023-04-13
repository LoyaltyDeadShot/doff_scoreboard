--  AUTHOR: DoFF - https://github.com/daroczi/doff_scoreboard
-- 
-- /$$$$$$$          /$$$$$$$$/$$$$$$$$        /$$$$$$                                     /$$                                       /$$
-- | $$__  $$        | $$_____| $$_____/       /$$__  $$                                   | $$                                      | $$
-- | $$  \ $$ /$$$$$$| $$     | $$            | $$  \__/ /$$$$$$$ /$$$$$$  /$$$$$$  /$$$$$$| $$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$$
-- | $$  | $$/$$__  $| $$$$$  | $$$$$         |  $$$$$$ /$$_____//$$__  $$/$$__  $$/$$__  $| $$__  $$/$$__  $$|____  $$/$$__  $$/$$__  $$
-- | $$  | $| $$  \ $| $$__/  | $$__/          \____  $| $$     | $$  \ $| $$  \__| $$$$$$$| $$  \ $| $$  \ $$ /$$$$$$| $$  \__| $$  | $$
-- | $$  | $| $$  | $| $$     | $$             /$$  \ $| $$     | $$  | $| $$     | $$_____| $$  | $| $$  | $$/$$__  $| $$     | $$  | $$
-- | $$$$$$$|  $$$$$$| $$     | $$            |  $$$$$$|  $$$$$$|  $$$$$$| $$     |  $$$$$$| $$$$$$$|  $$$$$$|  $$$$$$| $$     |  $$$$$$$
-- |_______/ \______/|__/     |__/             \______/ \_______/\______/|__/      \_______|_______/ \______/ \_______|__/      \_______/
-- 

ESX = nil

if Config.legacy then
	ESX = exports["es_extended"]:getSharedObject()
else
	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
	
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end
		ESX.PlayerData = ESX.GetPlayerData()
	
	end)
end


local connectedPlayers, maxPlayers = {}, GetConvarInt('sv_maxclients', 32)
local playersData = {}
local playersDataLogged = {}
local playersDataActuall = {}
local playersDataLevels = {}

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM users', {}, function(result)	
        for i=1, #result, 1 do
            playersData[result[i].identifier] = result[i].time
            playersDataLogged[result[i].identifier] = result[i].login
		end
    end)
end)

ESX.RegisterServerCallback('doff_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers, maxPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name
	TriggerClientEvent('doff_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(source, playerId, xPlayer)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
	local uptime = playersData[identifier]
	print ("Idő: " .. uptime)
	playersDataLevels[identifier] = uptime
	uptime = SecondsToClock(uptime)
	TriggerClientEvent('doff_scoreboard:setUptime', source, uptime)

	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil
	dropPlayer(playerId)
	TriggerClientEvent('doff_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.pingRefreshTime)
		UpdatePing()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(1000)
		AddPlayersToScoreboard()
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source
	local identifier = xPlayer.identifier

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].ping = GetPlayerPing(playerId)
	connectedPlayers[playerId].playerId = playerId
	connectedPlayers[playerId].uptime = playersDataLevels[identifier]

    if Config.rpName == true then
        connectedPlayers[playerId].name = Sanitize(xPlayer.getName())
    else
        connectedPlayers[playerId].name = Sanitize(GetPlayerName(playerId))
    end
	connectedPlayers[playerId].job = xPlayer.job.name

	if update then
		TriggerClientEvent('doff_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end

end

function AddPlayersToScoreboard()
	local players = ESX.GetPlayers()

	for i=1, #players do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('doff_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

function UpdatePing()
	for playerId,v in pairs(connectedPlayers) do
		local ping = GetPlayerPing(playerId)

		if ping and ping > 0 then
			v.ping = ping
		else
			v.ping = 'missing'
		end
	end

	TriggerClientEvent('doff_scoreboard:updatePing', -1, connectedPlayers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

function SecondsToClock(seconds)
    if seconds ~= nil then
        local seconds = tonumber(seconds)

        if seconds <= 0 then
            return "00h 00m";
        else
            hours = string.format("%02.f", math.floor(seconds/3600));
            mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
            -- secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
            return hours.."h "..mins.."m"--..":"..secs
        end
    end
end

function dropPlayer(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local actuallTime = os.time()
    local name = GetPlayerName(source)
	print("Object #1" .. json.encode(playersData))
	print("Object #2" .. json.encode(playersDataActuall))
    if(playersData[identifier] ~= nil and playersDataActuall[identifier] ~= nil) then
        local time = tonumber(actuallTime - playersDataActuall[identifier])
        local timeFormatted = SecondsToClock(time)
        local timeAll = time + playersData[identifier]
        local timeAllFormatted = SecondsToClock(timeAll)

        MySQL.Async.execute('UPDATE users SET time = @time WHERE identifier = @identifier',
            {['time'] = timeAll, ['identifier'] = identifier},
            function(affectedRows)
            --   print('Drop logged')
            end
        )
        playersData[identifier] = timeAll
    end
end


RegisterNetEvent('doff_scoreboard:loggedIn')
AddEventHandler('doff_scoreboard:loggedIn', function(playerName)
	local _source = source	
    local _playerName = playerName
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    local actuallTime = os.time()
   
    if playersData[identifier] ~= nil then
        playersDataActuall[identifier] = actuallTime
        playersDataLogged[identifier] = tonumber(playersDataLogged[identifier]) + 1
        local totaltimeFormatted = SecondsToClock(playersData[identifier])
        MySQL.Async.execute('UPDATE users SET login = login + 1 WHERE identifier = @identifier',
            {['identifier'] = identifier},
            function(affectedRows)
            --   print('Updated login')
            end
        )
    end
end)

RegisterCommand('time2', function(source)
	dropPlayer(source)
end, false)