local module = {}

local events : Folder = game.ReplicatedStorage.Connection.Egg
local boughtEgg : RemoteFunction = events.BoughtEgg

function module.attemptHatch(player: Player, egg: Model)
    local result = boughtEgg:InvokeServer(egg)

    if (result == true) then
        --Play animation
        print("Play Animation")
    else
        print("Don't play animation due to failure")
    end
end

return module;