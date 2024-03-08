local events : Folder = game.ReplicatedStorage.Connection.Egg
local boughtEgg : RemoteFunction = events.BoughtEgg

local EggController : ModuleScript = require(script.EggModule.EggController)

local PlayerData : ModuleScript = require(script.PlayerModule.AllPlayersData)

local deletePet : RemoteEvent = game.ReplicatedStorage.Connection.Egg.deletePet


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

deletePet.OnServerEvent:Connect(function(player : Player, pet : table)
    local data : table = PlayerData["Players"][player.Name]["Backpack"]
    local pD : table = data["Items"][pet.Name]
    if(pD) then
        data["Items"][pet.Name] = nil
        data.usedSpace -= 1
    else
        print("The pet doesn't exist in the player's backpack")
    end
end)
