-- Unfortunately I had to make the physics client sided for this to work

local main = script.Parent
local Button = main.WaitChild("Button")
local SpawnPart = main.WaitChild("Spawn")
local Boxes = Hidden.WaitChild("Boxes")
local Text = main.WaitChild("Text3D")

local prevBoxes = nil

local cooldown = 5

local idleColor = Button.Color
local activeColor = Color.FromRGB(255,0,0)

local idleText = "Regen Boxes"
local activeText = "..."

local function shouldSpawn()
	return true --#SpawnPart.GetTouching() == 0
end

local lastSpawnTime = 0
local function spawnBoxes(_plr)
	if (os.clock() - lastSpawnTime) < cooldown or not shouldSpawn() then return end
	
	if prevBoxes then
		prevBoxes.Destroy()
		prevBoxes = nil
	end
	
	Button.Color = activeColor
	Text.Text = activeText
	
	lastSpawnTime = os.clock()
	
	local newBoxes = Boxes.Clone()
	newBoxes.Position = SpawnPart.Position
	newBoxes.Rotation = SpawnPart.Rotation
	newBoxes.Parent = Environment
	for _, box in newBoxes:GetChildren() do
		if box then
			box.Anchored = false
		end
	end
	
	prevBoxes = newBoxes
	
	wait(cooldown)
	
	Text.Text = idleText
	Button.Color = idleColor
end

spawnBoxes()

Button.Clicked:Connect(spawnBoxes)