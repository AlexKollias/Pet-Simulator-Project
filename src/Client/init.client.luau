local hatchEgg = require(script.Egg.HatchEgg)

local player : Player = script.Parent.Parent
local char = player.CharacterAdded:Wait()

local event : RemoteEvent = game.ReplicatedStorage.Connection.Backpack.BackpackChanged

local thread = coroutine.create(function()
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

event.OnClientEvent:Connect(function(data : table)
    print(data)
end)