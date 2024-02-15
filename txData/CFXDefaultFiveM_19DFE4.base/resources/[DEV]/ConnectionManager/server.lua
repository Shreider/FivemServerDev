local function AddToPlayersData(NetId)
    MySQL.Async.fetchAll("SELECT playersdata.steamid FROM playersdata, playersonline WHERE playersonline.NetId = @NetId AND playersonline.steamid = playersdata.steamid",
        {["@NetId"] = NetId},
        function(data)
            if #data ~= 0 then
                return
            else
                MySQL.Async.fetchAll("INSERT INTO PlayersData (steamid) SELECT steamid FROM PlayersOnline WHERE NetId = @NetId",
                    {["@NetId"] = NetId}
                )
            end
        end
    )
end
RegisterNetEvent('AddToPlayersData')
AddEventHandler('AddToPlayersData', AddToPlayersData)

-----------------------------------------------------------

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)

    deferrals.defer()
    Wait(0)
    deferrals.update("Your SteamID is being checked.")

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
        elseif string.find(v, "ip") then
            ipIdentifier = v
        end
    end
    
    Wait(0)

    if not steamIdentifier then
        deferrals.done("You are not connected to Steam.")
        print('Connecting failed for '..name..' (You are not connected to Steam)')
    else
        deferrals.done()
        MySQL.Async.execute("INSERT INTO PlayersOnline (ip, steamid, NetId) VALUES (@ip, @steamid, @tempNetId)",
            {["@steamid"] = steamIdentifier, ["@tempNetId"] = player, ['@ip'] = ipIdentifier}
        )
    end
end
AddEventHandler("playerConnecting", OnPlayerConnecting)

-----------------------------------------------------------

local function OnPlayerJoining(oldId)
    local tempNetId = oldId
    local NetId = source
    local PlayerName = GetPlayerName(NetId)

    MySQL.Async.fetchAll("SELECT steamid, ip FROM PlayersOnline WHERE NetId = @tempNetId",
        {["@tempNetId"] = tempNetId},
        function(data)
            local steamid
            local ip
            for _, j in ipairs(data) do
                steamid = j.steamid
                ip = j.ip
            end
            --[[MySQL.Async.execute("INSERT INTO PlayersOnline (ip, steamid, NetId, PlayerName) VALUES (@ip, @steamid, @NetId, @PlayerName)",
                {["@steamid"] = steamid, ["@NetId"] = NetId, ["@PlayerName"] = PlayerName, ['@ip'] = ip}
            )
            Citizen.Wait(500)
            MySQL.Async.fetchAll("DELETE FROM PlayersOnline WHERE NetId = @tempNetId",
                {["@tempNetId"] = tempNetId}
            )]]

            MySQL.Async.transaction(
                {
                    'UPDATE PlayersOnline SET ip = @ip WHERE NetId = @tempnetid',
                    'UPDATE PlayersOnline SET steamid = @steamid WHERE NetId = @tempnetid',
                    'UPDATE PlayersOnline SET playername = @playername WHERE NetId = @tempnetid',
                    'UPDATE PlayersOnline SET NetID = @netid WHERE NetId = @tempnetid'
                    
                },
                { 
                    ['tempnetid'] = tempNetId,
                    ['netid'] = NetId,
                    ['ip'] = ip,
                    ['steamid'] = steamid,
                    ['playername'] = PlayerName
                }
            )

        end
    )

    print('['..NetId..'] '..PlayerName..' joined!')
end
AddEventHandler('playerJoining', OnPlayerJoining)

----------------------------------------------------------------

AddEventHandler('playerDropped', function (reason)
    MySQL.Async.fetchAll("DELETE FROM PlayersOnline WHERE NetId = @NetId",
        {["@NetId"] = source}
    )
    local PlayerName = GetPlayerName(source)
    print('['..source..'] '..PlayerName..' left! ('..reason..')')  
end)