local hatchEgg = require(script.Egg.HatchEgg)

local player : Player = script.Parent.Parent
local char = player.CharacterAdded:Wait()

for _,v : Model in pairs(workspace.Eggs:GetChildren()) do
	local pressE : ProximityPrompt = v:FindFirstChild("Base"):FindFirstChild("ProximityPrompt")
	print(pressE)
	print(v)
    pressE.Triggered:Connect(function(plr : Player)
        hatchEgg.attemptHatch(plr,v)
    end)
end