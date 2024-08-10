-- loads target menu on ped for purchases
LoadMenu = function(data, shop)
    -- create list for vehicles
    local vehicles = {}
    -- load vehicles into list
    for key, value in pairs(data) do
        vehicles[#vehicles+1] = {
            title = value.make..', '..value.model,
            description = '$'..value.maxcost,
            image = value.image,
            onSelect = function()
                if Debug then
                    lib.print.info('Make: '..value.make..', Model: '..value.model)
                end LoadVehicle_View(key, shop)
            end,
        }
    end
    -- show list options in menu
    lib.registerContext({
        id = 'list',
        title = 'Listed Vehicles',
        menu = 'shop_pdm',
        options = vehicles
    })
    -- load context menu
    lib.showContext('list')
end

-- loads blip for location
LoadBlip = function(shop)
    local blip = AddBlipForCoord(
    shop.loc.x, shop.loc.y, shop.loc.z)
    SetBlipSprite(blip, shop.spr)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, shop.scl)
    SetBlipColour(blip, shop.clr)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(shop.label)
    EndTextCommandSetBlipName(blip)
end

-- loads ped for purchases
LoadPed = function(ped, mdl, loc, scn, ops)
    -- create ped
    ped = CreatePed(1, mdl, loc.x, loc.y, loc.z-1.0, loc.w, true, false)
    TaskStartScenarioInPlace(ped, scn, 0, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    -- use netID to assign options
    local netId = NetworkGetNetworkIdFromEntity(ped)
    exports.ox_target:addEntity(netId, ops)
end

-- loads vehicle for physical viewing
LoadVehicle_View = function(data, shop)
    if Debug then lib.print.info('Model xfrd: '..data) end

    -- notify player of spawn location
    local txt1 = {
        id = 'veh_display', tx = 'Vehicle Ready for View',
        dc = 'the chosen vehicle is in the garage to be configured'
    } DoNotify(txt1, Inf)

    -- spawn vehicle in garage location
    local vehicle = lib.callback.await('mi_veh:s:create:vehicle', false, source, data, shop)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleEngineOn(vehicle, false, true, true)
    if Debug then lib.print.info('Spawn: '..shop.spawn..'| Head: '..shop.head) end

    -- tansport player to mechanic / vehicle
    local tpm = shop.ended
    Wait(200)
    Teleport(cache.ped, tpm.x, tpm.y, tpm.z, tpm.w)

    -- open mechanic menu
    --SetVehicle_Details(data)
    lib.setVehicleProperties(vehicle, { color1 = 111 })
    lib.setVehicleProperties(vehicle, { color2 = 72 })
end

SetVehicleProperties = function(vehicle, properties)
    if vehicle == nil then
        if Debug then lib.print.error('no vehicle found') end
    else
        lib.setVehicleProperties(vehicle, properties)
    end
end

-- sets details for purchased vehicle
SetVehicle_Details = function(vehicle)
    local title = 'Customize your vehicle'
    local options = { allowCancel = false }
    local input = lib.inputDialog(title, {
        {
            type = 'select', label = 'Paint', description = 'Select initial color for your new vehicle',
            icon = 'fill', required = true, options = {
                { value = 111,  label = "White" },
                { value = 10,   label = "Grey" },
                { value = 1,    label = "Black" },
                { value = 27,   label = "Red" },
                { value = 38,   label = "Orange" },
                { value = 89,   label = "Yellow" },
                { value = 53,   label = "Green" },
                { value = 64,   label = "Blue" },
                { value = 145,  label = "Purple" }
            }
        },
        {
            type = 'select', label = 'License Plate', description = 'Select your S.A. license plate style',
            icon = 'address-card', required = true, options = {
                { value = 0,  label = "Blue/White" },
                { value = 1,   label = "Yellow/black" },
                { value = 2,    label = "Yellow/Blue" }
            }
        },
      }, options)
      lib.print.info(json.encode(input), input[1], input[2])
    --set properties for vehicle
    lib.print.info('Vehicle: '..vehicle)
    local props = { color1 = input[1], color2 = input[1], plate = input[2] }
    local netId = NetworkGetEntityFromNetworkId(vehicle)
    lib.print.info(netId)
    lib.setVehicleProperties(vehicle, { color1 = input[1] })
    lib.setVehicleProperties(vehicle, { color2 = input[1] })
end

RegisterCommand('testinp', function()
    local title = 'Customize your vehicle'
    local options = { allowCancel = false }
    local input = lib.inputDialog(title, {
        {
            type = 'select', label = 'Paint', description = 'Select initial color for your new vehicle',
            icon = 'fill', required = true, options = {
                { value = 111,  label = "White" },
                { value = 10,   label = "Grey" },
                { value = 1,    label = "Black" },
                { value = 27,   label = "Red" },
                { value = 38,   label = "Orange" },
                { value = 89,   label = "Yellow" },
                { value = 53,   label = "Green" },
                { value = 64,   label = "Blue" },
                { value = 145,  label = "Purple" }
            }
        },
        {
            type = 'select', label = 'License Plate', description = 'Select your S.A. license plate style',
            icon = 'address-card', required = true, options = {
                { value = 0,  label = "Blue/White" },
                { value = 1,   label = "Yellow/black" },
                { value = 2,    label = "Yellow/Blue" }
            }
        },
      }, options)
      lib.print.info(json.encode(input), input[1], input[2])
end, false)