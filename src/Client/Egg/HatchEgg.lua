local module = {}

local anim = require(script.Parent.Animation)

local events : Folder = game.ReplicatedStorage.Connection.Egg
local boughtEgg : RemoteFunction = events.BoughtEgg

function module.attemptHatch(player: Player, egg: Model)
    local result : boolean , pet : Model = boughtEgg:InvokeServer(egg)

    if (result == true) then
        --Play animation
        anim.PlayAnimation(player,egg,pet)
        print("Play Animation")
    else
        print("Don't play animation due to failure")
    end
end

return module;