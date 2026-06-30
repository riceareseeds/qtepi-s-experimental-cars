local car = script.Parent
local sound = car.WaitChild("EngineSound")

sound:Play()

local pitchEffect = 0.01

function _Update()
	sound.Pitch = (car.Velocity.Magnitude*pitchEffect)+1
end