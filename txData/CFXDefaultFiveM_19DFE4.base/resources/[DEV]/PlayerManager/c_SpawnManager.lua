function SetAutoSpawn(bool)
    exports.spawnmanager:setAutoSpawn(bool)
end

Citizen.CreateThread(function()
    SetAutoSpawn(false)
end)

function Spawn(x,y,z,h)
    exports.spawnmanager:spawnPlayer({
        x = x,
        y = y,
        z = z,
        heading = h,
        skipFade = false
    })
end

function Revive()
    local c = GetEntityCoords(PlayerPedId())
    Spawn(c.x, c.y, c.z+1, GetEntityHeading(PlayerPedId()))
end

RegisterCommand('rev', function(source, args, RawCommand)
    Revive()
end)