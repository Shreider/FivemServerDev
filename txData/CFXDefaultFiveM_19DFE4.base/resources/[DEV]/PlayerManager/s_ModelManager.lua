RegisterNetEvent('server:savePlayerModel')
AddEventHandler('server:savePlayerModel', function(NetId, ModelData)
    MySQL.Async.fetchAll('SELECT steamid FROM PlayersOnline WHERE NetId = @NetId',
        {
            ['NetId'] = NetId
        },
        function(result)
            Citizen.Await(result)
            local steamid = result[1].steamid

            MySQL.Async.transaction(
                {
                    -- MASK --
                    'UPDATE PlayersData SET model_mask_index = @mask_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_mask_var = @mask_var WHERE steamid = @steamid',
                    -- HAIR --
                    'UPDATE PlayersData SET model_hair_index = @hair_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_hair_var = @hair_var WHERE steamid = @steamid',
                    -- TORSO --
                    'UPDATE PlayersData SET model_torso_index = @torso_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_torso_var = @torso_var WHERE steamid = @steamid',
                    -- LEG --
                    'UPDATE PlayersData SET model_leg_index = @leg_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_leg_var = @leg_var WHERE steamid = @steamid',
                    -- BAG --
                    'UPDATE PlayersData SET model_bag_index = @bag_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_bag_var = @bag_var WHERE steamid = @steamid',
                    -- SHOES --
                    'UPDATE PlayersData SET model_shoes_index = @shoes_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_shoes_var = @shoes_var WHERE steamid = @steamid',
                    -- ACCESSORY --
                    'UPDATE PlayersData SET model_accessory_index = @accessory_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_accessory_var = @accessory_var WHERE steamid = @steamid',
                    -- UNDERSHIRT --
                    'UPDATE PlayersData SET model_undershirt_index = @undershirt_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_undershirt_var = @undershirt_var WHERE steamid = @steamid',
                    -- KEVLAR --
                    'UPDATE PlayersData SET model_kevlar_index = @kevlar_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_kevlar_var = @kevlar_var WHERE steamid = @steamid',
                    -- BADGE --
                    'UPDATE PlayersData SET model_badge_index = @badge_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_badge_var = @badge_var WHERE steamid = @steamid',
                    -- TORSO2 --
                    'UPDATE PlayersData SET model_torso2_index = @torso2_index WHERE steamid = @steamid',
                    'UPDATE PlayersData SET model_torso2_var = @torso2_var WHERE steamid = @steamid'
                    
                },
                { 
                    ['steamid'] = steamid,
                    -- MASK --
                    ['mask_index'] = ModelData.Mask.index, 
                    ['mask_var'] = ModelData.Mask.var,
                    -- HAIR --
                    ['hair_index'] = ModelData.Hair.index, 
                    ['hair_var'] = ModelData.Hair.var, 
                    -- TORSO --
                    ['torso_index'] = ModelData.Torso.index, 
                    ['torso_var'] = ModelData.Torso.var,
                    -- LEG --
                    ['leg_index'] = ModelData.Leg.index, 
                    ['leg_var'] = ModelData.Leg.var,
                    -- BAG --
                    ['bag_index'] = ModelData.Bag.index, 
                    ['bag_var'] = ModelData.Bag.var,
                    -- SHOES --
                    ['shoes_index'] = ModelData.Shoes.index, 
                    ['shoes_var'] = ModelData.Shoes.var,
                    -- ACCESSORY --
                    ['accessory_index'] = ModelData.Accessory.index, 
                    ['accessory_var'] = ModelData.Accessory.var,
                    -- UNDERSHIRT --
                    ['undershirt_index'] = ModelData.Undershirt.index, 
                    ['undershirt_var'] = ModelData.Undershirt.var,
                    -- KEVLAR --
                    ['kevlar_index'] = ModelData.Kevlar.index, 
                    ['kevlar_var'] = ModelData.Kevlar.var,
                    -- BADGE --
                    ['badge_index'] = ModelData.Badge.index, 
                    ['badge_var'] = ModelData.Badge.var,
                    -- TORSO2 --
                    ['torso2_index'] = ModelData.Torso2.index, 
                    ['torso2_var'] = ModelData.Torso2.var
                }
            )
        end
    )
end)

RegisterNetEvent('server:loadPlayerModel')
AddEventHandler('server:loadPlayerModel', function(NetId)
    MySQL.Async.fetchAll('SELECT steamid FROM PlayersOnline WHERE NetId = @NetId',
        {
            ['NetId'] = NetId
        },
        function(result)
            Citizen.Await(result)
            local steamid = result[1].steamid

            MySQL.Async.fetchAll('SELECT steamid, model_mask_index, model_mask_var, model_hair_index, model_hair_var, model_torso_index, model_torso_var, model_leg_index, model_leg_var, model_bag_index, model_bag_var, model_shoes_index, model_shoes_var, model_accessory_index, model_accessory_var, model_undershirt_index, model_undershirt_var, model_kevlar_index, model_kevlar_var, model_badge_index, model_badge_var, model_torso2_index, model_torso2_var FROM PlayersData WHERE steamid = @steamid',
                {
                    ['steamid'] = steamid
                },
                function(result)
                    Citizen.Await(result)
                    local modeldata = result[1]
                    TriggerClientEvent('client:loadPlayerModel', NetId, modeldata)
                end
            )
        end
    )
end)