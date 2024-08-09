-- variables
local vehicleNet
local Inventory = exports.ox_inventory

-- get net id function
local getNetId = function(ent)
    Citizen.Wait(100)
    local vNetId = NetworkGetEntityFromNetworkId(ent)
    if Debug then print(vNetId) end
    return vNetId
end

-- create initial vehicle
lib.callback.register('mi_veh:s:create:vehicle', function(source, ent, model, shop)
    local player = Ox.GetPlayer(source)
    print('player')
    ent = Ox.CreateVehicle({
        model = model, owner = player.charid,
    }, shop.spawn, shop.head)
    print('creation')
    -- load vehicle properties
    vehicleNet = getNetId(ent)
    if Debug then
        print(player.stateId, ent) print(vehicleNet)
    end
    print('net')
end)

-- recreate vehicle from db and spawn with player inside

RegisterServerEvent('mi_veh:s:load:pdm')
AddEventHandler('mi_veh:s:load:pdm', function()
    TriggerClientEvent('mi_veh:c:load:pdm', 1)
    if Debug then print('loadpdm: s -> c') end
end)