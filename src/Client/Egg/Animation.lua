local module = {}

local camera : Camera = workspace:FindFirstChild("Camera")

local ts = game:GetService("TweenService")

function module.PlayAnimation(player : Player, egg : Model, pet : Model)
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = egg:FindFirstChild("CameraPart").CFrame

    -- Co-ordinates for items in view port frame: Position: 0, 0, -6 | Orientation: 0, 90, 0

    local gui : ScreenGui = game.ReplicatedStorage:WaitForChild("EggHatchGUI")
    local vpf : ViewportFrame = gui:FindFirstChild("ViewportFrame")

    local eggClone : MeshPart = egg:FindFirstChild("Egg"):Clone()

    eggClone.Parent = vpf
    eggClone.Position = Vector3.new(0,0,-6)

    local petClone : Model = pet:Clone()
    petClone.Parent = vpf
    petClone.PrimaryPart.Position = Vector3.new(0,0,-11)
    petClone.PrimaryPart.Orientation = Vector3.new(0,180,0)
    
    
    gui.Parent = player:FindFirstChild("PlayerGui")
	
	local n = 0.4
	local orient = 20
    local shakes = 2
	
	for _ = 1,shakes do
		local tweenInfo = TweenInfo.new(n,Enum.EasingStyle.Elastic,Enum.EasingDirection.InOut,0,true,0.1)
		local tween1 = ts:Create(eggClone, tweenInfo, {Orientation = Vector3.new(orient,90,0)})
		local tween2 = ts:Create(eggClone, tweenInfo, {Orientation = Vector3.new(-orient,90,0)})
		
		tween1:Play()
		task.wait(n)
		tween2:Play()
		task.wait(n)
		n -= 0.2
		orient += 5
	end

    local tween3 = ts:Create(eggClone, TweenInfo.new(0.5), {Position = Vector3.new(0,20,-6)})
    tween3:Play()
    
    --Pet positions: Position: 0, 2, -9 tween to 0,2,-6 | Orientation: Fixed at 0,180,0
	
    local tweenInfo : TweenInfo = TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0.1)
    local tween1 : Tween = ts:Create(petClone.PrimaryPart, tweenInfo, {Position = Vector3.new(0,0,-6)})
    
    tween1:Play()
    task.wait(0) -- Should be 3 for a more dramatic effect ,just trying to speed things up

    local tween2 : Tween = ts:Create(petClone.PrimaryPart, tweenInfo, {Position = Vector3.new(0,-15,-6)})

    tween2:Play() -- This is the drop, I nee to make it 1s. Testing with 4 secs delay is killing me 
    task.wait(0) 

    gui.Parent = game.ReplicatedStorage

    camera.CameraType = Enum.CameraType.Custom
end


return module;