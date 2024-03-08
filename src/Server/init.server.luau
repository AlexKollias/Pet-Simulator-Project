local events : Folder = game.ReplicatedStorage.Connection.Egg
local boughtEgg : RemoteFunction = events.BoughtEgg

local EggController : ModuleScript = require(script.EggModule.EggController)

local PlayerData : ModuleScript = require(script.PlayerModule.AllPlayersData)


game.Players.PlayerAdded:Connect(function(player : Player)
    PlayerData.makePlayerData(player)
    PlayerData.makeLeaderstats(player)

    local coins : IntValue = player.leaderstats.Coins
    coins:GetPropertyChangedSignal("Value"):Connect(function()
        PlayerData.UpdateData(player, "leaderstats", "Coins", coins.Value)
    end)

    print(PlayerData)
    player.CharacterAdded:Connect(function(char : Model)
        local PetEquippedFolder : Folder = Instance.new("Folder")
        PetEquippedFolder.Parent = workspace:FindFirstChild("PlayerEggs")
        PetEquippedFolder.Name = player.Name
    end)
end)


boughtEgg.OnServerInvoke = function(player : Player, egg : Model)
    return EggController.BoughtEgg(player, egg)
end




