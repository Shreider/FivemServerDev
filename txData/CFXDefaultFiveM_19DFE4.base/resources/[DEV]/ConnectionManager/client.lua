Citizen.CreateThread(function()
    local NetId = GetPlayerServerId(PlayerId())
    TriggerServerEvent('AddToPlayersData', NetId)
end)