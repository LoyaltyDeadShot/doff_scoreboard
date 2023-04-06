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
ESX = exports["es_extended"]:getSharedObject()
local connectedPlayers, maxPlayers = {}, GetConvarInt('sv_maxclients', 32)

ESX.RegisterServerCallback('doff_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers, maxPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name
	TriggerClientEvent('doff_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil
	TriggerClientEvent('doff_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.pingRate)
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

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].ping = GetPlayerPing(playerId)
	connectedPlayers[playerId].playerId = playerId
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