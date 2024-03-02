local data = {
    Players = {}
}

local statsTable : table = {
    leaderstats = {
        Coins = 100;
    };
    Backpack = {
        Capacity = 30;
        usedSpace = 0;
        Items = {}
    }
}

function data.makePlayerData(player : Player)
    data.append(player, statsTable);
end

function data.makeLeaderstats(player : Player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Parent = leaderstats
    coins.Name = "Coins"
    coins.Value = statsTable.leaderstats.Coins;
end

function data.append(player : Player, newTable : table)
    data["Players"][player.Name] = newTable;
end

function data.AddToBackpack(player : Player, pet : Model, egg : Model)
    local plrBackpack = data["Players"][player.Name].Backpack
    plrBackpack.Items[pet.Name] = pet
    plrBackpack.Items[pet.Name]["Amount"] += 1
    data["Players"][player.Name].Backpack.usedSpace += 1;
    print(data["Players"][player.Name])
end

function data.GrabData(player : Player)
    return data["Players"][player.Name]
end

function data.decreaseMoney(player : Player, ammount : number)
    data["Players"][player.Name].leaderstats.Coins -= ammount;
end

function data.UpdateData(player : Player, dataParent : string, dataChild : string ,value)
    data["Players"][player.Name][dataParent][dataChild] = value; -- Updates the value of the data when the data is changed
end


return data;