local player : Player = script.Parent.Parent
local char : Model = player.Character or player.CharacterAdded:Wait() 

local playerGUI = player:WaitForChild("PlayerGui")
local backpackGUI : ScreenGui = playerGUI:FindFirstChild("BackpackGUI")
local bFrame : Frame = backpackGUI:FindFirstChild("BackpackFrame")
local petFrame : ScrollingFrame = bFrame:FindFirstChild("PetFrame")
local openBackBttn : TextButton = backpackGUI:FindFirstChild("OpenBackpack")
local closeBttn : TextButton = bFrame:FindFirstChild("Close")
local slot : Frame = game.ReplicatedStorage:FindFirstChild("Slot")

local event : RemoteEvent = game.ReplicatedStorage.Connection.Backpack.BackpackChanged

local hatchEgg : ModuleScript = require(script.Egg.HatchEgg)
local backpack : ModuleScript = require(script.BackpackModule.Backpack)

local rs = game:GetService("RunService")

local thread = coroutine.create(function() -- Put the function in another thread so that other functions can run because the attemptHatch function yields and thats a no no
    for _,v : Model in pairs(workspace.Eggs:GetChildren()) do
        local pressE : ProximityPrompt = v:FindFirstChild("Base"):FindFirstChild("ProximityPrompt")
        print(pressE)
        print(v)
        pressE.Triggered:Connect(function(plr : Player)
            pressE.Enabled = false
            hatchEgg.attemptHatch(plr,v)
            pressE.Enabled = true
        end)
    end
end)

coroutine.resume(thread)

rs.RenderStepped:Connect(function(dt)
    for j,folder in workspace:FindFirstChild("PlayerEggs"):GetChildren() do
        backpack.PositionPets(folder)
    end
    
end)

event.OnClientEvent:Connect(function(data : table, pet : table) -- If this fires it means new data has come in, hooray
    print(data)
    local backTable : table= data["Backpack"]
    local pets : table = backTable["Items"]
    
    local slotClone : ImageButton = slot:Clone()

    slotClone.Parent = petFrame
    slotClone.Image = pet.Image
    slotClone.Name = pet.Name .. math.random(100,999)

    slotClone.MouseButton1Click:Connect(function()
        backpack.OnClick(pet,slotClone,data["Backpack"])
    end)
end)

openBackBttn.Activated:Connect(function()
    print("openned")
    backpack.openCloseBackpack();
end)

closeBttn.Activated:Connect(function()
    print("closed")
    backpack.openCloseBackpack();
end)






