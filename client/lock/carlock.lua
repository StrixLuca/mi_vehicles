-- variables
local vehicleOps = {
    
}

-- local functions
IndicateVehLights = function(vehicle)
    if not vehicle then return end
    if vehicle then
        SetVehicleLights(vehicle, 2) Wait(200)
        SetVehicleLights(vehicle, 0) Wait(150)
        SetVehicleLights(vehicle, 2) Wait(500)
        SetVehicleLights(vehicle, 0)
    end
end

IndicateVehHorn = function(vehicle)
    if not vehicle then return end
    if vehicle then
        StartVehicleHorn(vehicle, 200, "HELDDOWN", false)
	    Wait(200)
	    StartVehicleHorn(vehicle, 150, "HELDDOWN", false)
    end
end

SetVehicleLocks = function(object)
    local vehicle
    local crds = GetEntityCoords(cache.ped)
    if not object then
        if IsPedInAnyVehicle(cache.ped, false) then
			object = GetVehiclePedIsIn(cache.ped, false)
		else
			object = lib.getClosestVehicle(crds, 8.0, true)
		end
        vehicle = object
    else
        if not DoesEntityExist(vehicle) then
            local data = { id = 'novehnear', tx = 'No Vehicle Nearby',
            dc = 'You are too far to utilize the locks'}
            DoNotify(data, Err)
            lib.print.info(data.tx)
        end
    end
end

RegisterCommand('carlock',function ()
	SetVehicleLocks()
	Wait(300)
end,false)