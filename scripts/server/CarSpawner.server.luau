local main = script.Parent
local Button = main.Button
local SpawnPart = main.Spawn
local Car = ServerHidden.Car
local Text = main.Text3D

local cooldown = 5

local idleColor = Button.Color
local activeColor = Color.FromRGB(255,0,0)

local idleText = "Spawn Car"
local activeText = "..."

local function shouldSpawn()
	return true --#SpawnPart.GetTouching() == 0
end

local lastSpawnTime = 0
local function spawnCar(_plr)
	if (os.clock() - lastSpawnTime) < cooldown or not shouldSpawn() then return end
	
	Button.Color = activeColor
	Text.Text = activeText
	
	lastSpawnTime = os.clock()
	
	local newCar = Car.Clone()
	newCar.Position = SpawnPart.Position
	newCar.Rotation = SpawnPart.Rotation
	newCar.Parent = Environment
	newCar.CarServerScript.IsEnabled = true
	newCar.CarSoundScript.IsEnabled = true
	
	wait(cooldown)
	
	Text.Text = idleText
	Button.Color = idleColor
end

spawnCar()

Button.Clicked:Connect(spawnCar)