local car = script.Parent
local DriversSeat = car.DriversSeat
local Base = car.Base

car.SetNetworkAuthority(nil) -- Make sure the car can't be tampered with by exploiters

local function doesPlayerExist(plr)
	return (plr and plr.Name and Players.GetPlayer(plr.Name))
end

DriversSeat.Sat:Connect(function(plr)
	if not doesPlayerExist(plr) then return end -- making sure it is a player
	plr.CanCollide = false -- This is so that the player doesn't collide with the car as they are sitting down
	car.SetNetworkAuthority(plr) -- This gives the player permission to handle the physics of the car and replicate it on to the server
end)

DriversSeat.Vacated:Connect(function(plr)
	if not doesPlayerExist(plr) then return end
	plr.CanCollide = true
	car.SetNetworkAuthority(nil)
end)