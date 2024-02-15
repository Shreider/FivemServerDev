local NetId = GetPlayerServerId(PlayerId())

local PlayerModelData = {
    -- DEFAULT VALUES --
    FaceBlend = {
        shapeFirstID = 0, -- Controls the shape of the first ped's face 
        shapeSecondID = 0, -- Controls the shape of the second ped's face 
        shapeThirdID = 0, -- Controls the shape of the third ped's face
        skinFirstID = 0, -- Controls the first id's skin tone
        skinSecondID = 0, -- Controls the second id's skin tone
        skinThirdID = 0, -- Controls the third id's skin tone
        shapeMix = 0, -- 0.0 - 1.0 Of whose characteristics to take Mother -> Father (shapeFirstID and shapeSecondID)
        skinMix = 0, -- 0.0 - 1.0 Of whose characteristics to take Mother -> Father (skinFirstID and skinSecondID)
        thirdMix = 0, -- Overrides the others in favor of the third IDs.
        isParent = false -- IsParent is set for "children" of the player character's grandparents during old-gen character creation. It has unknown effect otherwise.
    },
    Face = { index, var },
    Mask = { index, var },
    Hair = { index ,var },
    Torso = { index, var },
    Leg = { index, var },
    Bag = { index, var },
    Shoes = { index, var },
    Accessory = { index, var },
    Undershirt = { index, var },
    Kevlar = { index, var },
    Badge = { index, var },
    Torso2 = { index, var }
}

function UpdateModel()
    editFaceBlend()
    editFace()
    editMask()
    editHair()
    editTorso()
    editLeg()
    editBag()
    editShoes()
    editAccessory()
    editUndershirt()
    editKevlar()
    editBadge()
    editTorso2()
end

function UpdateModelData(editModelElement, index, var)
    if editModelElement == 'mask' then
        PlayerModelData.Mask.index = index
        PlayerModelData.Mask.var = var
    elseif editModelElement == 'hair' then
        PlayerModelData.Hair.index = index
        PlayerModelData.Hair.var = var
    elseif editModelElement == 'torso' then
        PlayerModelData.Torso.index = index
        PlayerModelData.Torso.var = var
    elseif editModelElement == 'leg' then
        PlayerModelData.Leg.index = index
        PlayerModelData.Leg.var = var
    elseif editModelElement == 'bag' then
        PlayerModelData.Bag.index = index
        PlayerModelData.Bag.var = var
    elseif editModelElement == 'shoes' then
        PlayerModelData.Shoes.index = index
        PlayerModelData.Shoes.var = var
    elseif editModelElement == 'accessory' then
        PlayerModelData.Accessory.index = index
        PlayerModelData.Accessory.var = var
    elseif editModelElement == 'undershirt' then
        PlayerModelData.Undershirt.index = index
        PlayerModelData.Undershirt.var = var
    elseif editModelElement == 'kevlar' then
        PlayerModelData.Kevlar.index = index
        PlayerModelData.Kevlar.var = var
    elseif editModelElement == 'badge' then
        PlayerModelData.Badge.index = index
        PlayerModelData.Badge.var = var
    elseif editModelElement == 'torso2' then
        PlayerModelData.Torso2.index = index
        PlayerModelData.Torso2.var = var
    else
        return
    end
end

function UpdateModelDBData()
    TriggerServerEvent('server:savePlayerModel', NetId, PlayerModelData)
end

RegisterNetEvent('client:loadPlayerModel')
AddEventHandler('client:loadPlayerModel', function(ModelData)
    UpdateModelData('mask', tonumber(ModelData.model_mask_index), tonumber(ModelData.model_mask_var))
    UpdateModelData('hair', tonumber(ModelData.model_hair_index), tonumber(ModelData.model_hair_var))
    UpdateModelData('torso', tonumber(ModelData.model_torso_index), tonumber(ModelData.model_torso_var))
    UpdateModelData('leg', tonumber(ModelData.model_leg_index), tonumber(ModelData.model_leg_var))
    UpdateModelData('bag', tonumber(ModelData.model_bag_index), tonumber(ModelData.model_bag_var))
    UpdateModelData('shoes', tonumber(ModelData.model_shoes_index), tonumber(ModelData.model_shoes_var))
    UpdateModelData('accessory', tonumber(ModelData.model_accessory_index), tonumber(ModelData.model_accessory_var))
    UpdateModelData('undershirt', tonumber(ModelData.model_undershirt_index), tonumber(ModelData.model_undershirt_var))
    UpdateModelData('kevlar', tonumber(ModelData.model_kevlar_index), tonumber(ModelData.model_kevlar_var))
    UpdateModelData('badge', tonumber(ModelData.model_badge_index), tonumber(ModelData.model_badge_var))
    UpdateModelData('torso2', tonumber(ModelData.model_torso2_index), tonumber(ModelData.model_torso2_var))
    UpdateModel()
end)

function loadPlayerModel()
    TriggerServerEvent('server:loadPlayerModel', NetId)
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local ped = PlayerPedId()
    Citizen.Wait(500)
    SetPedDefaultComponentVariation(ped)
    Citizen.Wait(1000)
    loadPlayerModel()
end)

-- COMMAND TO EDIT MODEL --
RegisterCommand('modeledit', function(source, args, RawCommand)
    local editModelElement = args[1]
    local index = tonumber(args[2]) or 0
    local var = tonumber(args[3]) or 0

    UpdateModelData(editModelElement, index, var)
    Citizen.Wait(50)
    UpdateModelDBData()
    UpdateModel()
end)

RegisterCommand('propfix', function(source, args, RawCommand)
    loadPlayerModel()
end)


-- EDIT MODEL -- 
function editFaceBlend()
    SetPedHeadBlendData(PlayerPedId(), PlayerModelData.FaceBlend.shapeFirstID, PlayerModelData.FaceBlend.shapeSecondID, PlayerModelData.FaceBlend.shapeThirdID, PlayerModelData.FaceBlend.skinFirstID, PlayerModelData.FaceBlend.skinSecondID, PlayerModelData.FaceBlend.skinThirdID, PlayerModelData.FaceBlend.shapeMix, PlayerModelData.FaceBlend.skinMix, PlayerModelData.FaceBlend.thirdMix, PlayerModelData.FaceBlend.isParent)
end

function editFace()
    SetPedComponentVariation(PlayerPedId(), 0, PlayerModelData.Face.index, PlayerModelData.Face.var, 2)
end

function editMask()
    SetPedComponentVariation(PlayerPedId(), 1, PlayerModelData.Mask.index, PlayerModelData.Mask.var, 2)
end

function editHair()
    SetPedComponentVariation(PlayerPedId(), 2, PlayerModelData.Hair.index, PlayerModelData.Hair.var, 2)
end

function editTorso()
    SetPedComponentVariation(PlayerPedId(), 3, PlayerModelData.Torso.index, PlayerModelData.Torso.var, 2)
end

function editLeg()
    SetPedComponentVariation(PlayerPedId(), 4, PlayerModelData.Leg.index, PlayerModelData.Leg.var, 2)
end

function editBag()
    SetPedComponentVariation(PlayerPedId(), 5, PlayerModelData.Bag.index, PlayerModelData.Bag.var, 2)
end

function editShoes()
    SetPedComponentVariation(PlayerPedId(), 6, PlayerModelData.Shoes.index, PlayerModelData.Shoes.var, 2)
end

function editAccessory()
    SetPedComponentVariation(PlayerPedId(), 7, PlayerModelData.Accessory.index, PlayerModelData.Accessory.var, 2)
end

function editUndershirt()
    SetPedComponentVariation(PlayerPedId(), 8, PlayerModelData.Undershirt.index, PlayerModelData.Undershirt.var, 2)
end

function editKevlar()
    SetPedComponentVariation(PlayerPedId(), 9, PlayerModelData.Kevlar.index, PlayerModelData.Kevlar.var, 2)
end

function editBadge()
    SetPedComponentVariation(PlayerPedId(), 10, PlayerModelData.Badge.index, PlayerModelData.Badge.var, 2)
end

function editTorso2()
    SetPedComponentVariation(PlayerPedId(), 11, PlayerModelData.Torso2.index, PlayerModelData.Torso2.var, 2)
end