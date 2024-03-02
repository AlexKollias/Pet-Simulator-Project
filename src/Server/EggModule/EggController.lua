local module = {}

local eggData = require(script.Parent.EggData)
local PlayerData = require(script.Parent.Parent.PlayerModule.AllPlayersData)

function module.BoughtEgg(player : Player, egg : Model) : boolean
    local egg = eggData[egg.name]
    if (module.CanBuy(player,egg) == true) and (module.HasStorage(player,egg) == true) then
        player.leaderstats.Coins.Value -= egg.Price;
        PlayerData.decreaseMoney(player,egg.Price);
        
        local rarity = math.random(0,100)

        local counter = 0;
        for _,v : table in pairs(egg.Pets) do
            counter += v.Chance
            if (rarity <= counter) then
                -- send it to the backpack
                module.GivePet(player, v, egg)
                return true
            end
        end
    else
        return false;
    end 
end


function module.CanBuy(player : Player, egg : Model) : boolean
    local egg = eggData[egg.Name]
    local coins : IntValue = player:FindFirstChild("leaderstats"):FindFirstChild("Coins")

    if (coins.Value < egg.Price) then
        print("Not enough money")
        return false;
    end
    return true;
end

function module.HasStorage(player: Player, egg : Model) : boolean
    -- TODO: Implement after making backpack
    local plrData = PlayerData.GrabData(player)
    if (plrData["Backpack"]["usedSpace"] + 1 > plrData["Backpack"]["Capacity"]) then
        print("Not enough capacity")
        return false;
    end
    return true;
end

function module.GivePet(player : Player, pet : Model, egg : Model)
    -- TODO: Implement after making backpack
    PlayerData.AddToBackpack(player,pet,egg)
end



return module;