local car = nil
local DriversSeat = nil
local Wheels = nil

local localPlr = Players.LocalPlayer

local POWER = 80

local function updateVars()
	DriversSeat = localPlr.SittingIn
	car = DriversSeat.Parent
	Wheels = car.FindChild("Wheels"):GetChildren()
end

local function getTouchingAmount()
	local collisions = nil
	local touching = 0
	for _, wheel in Wheels do
		collisions = wheel.GetTouching()
		for _, item in collisions do
			if not item.CanCollide then
				table.remove(collisions, table.find(collisions, item))
			end
		end
		touching = math.max(touching, #collisions)
	end
	-- The wheels are expected to be detecting the car rigid body so we remove one to the touching
	return touching - 1
end

local DebugGUI = PlayerGUI.DebugGUI
local function updateDebugUI(speed, touching)
	DebugGUI.View.Label.Text = "Debug:\nSpeed: "..string.format("%f", speed).."\nTouching: "..tostring(touching)
end

local function getVelocityDirection()
	local velocity = car.Velocity -- Current velocity
	local forwardVector = car.Forward -- The direction "facing"

	local dot = velocity:Dot(forwardVector)

	if dot > 0 then -- Moving Forward
    return 1
	elseif dot < 0 then -- Moving Backward
    return -1
	else -- Not moving forward or backward (purely sideways/vertical, or stationary)
    return 0
	end
end

local function mainLoop(dt)
	local zCtrl = Input.GetAxis("Vertical").Value
	local spinCtrl = Input.GetAxis("Horizontal").Value
	
	local touching = getTouchingAmount()
	
	if touching > 0 then -- Car shouldn't move if it's not touching the ground
		car.AddRelativeForce(Vector3.New(0, 0, zCtrl*POWER), Enums.ForceMode.Impulse)
	else
		-- Allow flip if car gets stuck
		if math.round(car.Velocity.Magnitude*5000) == 0 then
			car.Rotation = car.Rotation*Vector3.New(0,1,0)
			car.Position = car.Position+Vector3.New(0,1,0)
		end
	end
	car.AddRelativeTorque(Vector3.New(0, -spinCtrl*POWER*getVelocityDirection(), 0), Enums.ForceMode.Impulse)
	
	updateDebugUI(car.Velocity.Magnitude, touching)
end

function _FixedUpdate(dt)
	if not (localPlr.SittingIn and localPlr.SittingIn.Name == "DriversSeat") then
		DebugGUI.Visible = false
		return 
	else
		updateVars()
		DebugGUI.Visible = true
	end
	mainLoop(dt)
end
