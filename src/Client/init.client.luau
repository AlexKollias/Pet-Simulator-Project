local player : Player = script.Parent.Parent
local char : Model = player.Character or player.CharacterAdded:Wait() 

local ts = game:GetService("TweenService")

local playerGUI = player:WaitForChild("PlayerGui")
local backpackGUI : ScreenGui = playerGUI:FindFirstChild("BackpackGUI")
local bFrame : Frame = backpackGUI:FindFirstChild("BackpackFrame")
local petFrame : ScrollingFrame = bFrame:FindFirstChild("PetFrame")
local openBackBttn : TextButton = backpackGUI:FindFirstChild("OpenBackpack")
local closeBttn : TextButton = bFrame:FindFirstChild("Close")
local slot : Frame = game.ReplicatedStorage:FindFirstChild("Slot")

local event : RemoteEvent = game.ReplicatedStorage.Connection.Backpack.BackpackChanged

local hatchEgg : ModuleScript = require(script.Egg.HatchEgg)

local petFolder = workspace:FindFirstChild("PlayerEggs"):FindFirstChild("deadgamer323")
local warning : TextLabel = backpackGUI:FindFirstChild("Warning")
local eFrame : Frame = bFrame:FindFirstChild("EquippedFrame")
local pEq : TextLabel = eFrame:FindFirstChild("PetsEquipped")

local pDataFrame : Frame = backpackGUI:FindFirstChild("PetData")

local rarityColors = {
    Common = BrickColor.new(211,211,211);
}
local hasEquipped = 0
local connection
local deleteConnection

local rs = game:GetService("RunService")

local thread = coroutine.create(function() -- Put the function in another thread so that other functions can run because the attemptHatch function yields and thats a no no
    for _,v : Model in pairs(workspace.Eggs:GetChildren()) do -- This handles the start of the egg hatching
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

rs.RenderStepped:Connect(function(dt) -- This is here in the client so that the player can see everyone's pets
    for _,folder in workspace:FindFirstChild("PlayerEggs"):GetChildren() do 
        PositionPets(folder) -- Get each players folder and position the pets
    end
    
end)

event.OnClientEvent:Connect(function(data : table, pet : table) -- If this fires it means new data has come in, hooray (it means we got a new pet)
    print(data)
    local backTable : table= data["Backpack"]
    local pets : table = backTable["Items"]
    
    local slotClone : ImageButton = slot:Clone()

    slotClone.Parent = petFrame
    slotClone.Image = pet.Image
    slotClone.Name = pet.Name .. math.random(100,999)

    slotClone.MouseButton1Click:Connect(function() -- If the slot of the pet is clicked it means the player wants to equip that's what this is doing
        OnClick(pet,slotClone,data["Backpack"])
    end)
end)

-- The two functions bellow are just here to open and close the backpack
openBackBttn.Activated:Connect(function()
    print("openned")
    openCloseBackpack();
end)

closeBttn.Activated:Connect(function()
    print("closed")
    openCloseBackpack();
end)

function openCloseBackpack()
    local openOrClosed = bFrame.Visible
    bFrame.Visible = not bFrame.Visible;
    
    if(openOrClosed) then
        pDataFrame.Visible = false
    end
end

function AddPet(pet : table) -- Adding the pet to the PetFrame 
    local petSlotClone : Frame = slot:Clone()
    petSlotClone.ImageLabel.Image = pet.Image
    petSlotClone.Name = pet.Name
    petSlotClone.Parent = petFrame
    petSlotClone.LayoutOrder = 10
end

local circle = math.pi * 2 -- This is just a cricle, basing the foundation of where the pets should be positioned
local minRadius = 4 -- In a circle we have an R this is it, it just says that the pets should be at a minimum 4 studs away

function PositionPets(petFolder : Folder)
    -- This is where we position the pets arround the player and give them a little spice and aniamtion
    for i,pet in petFolder:GetChildren() do
        local character : Model = workspace:FindFirstChild(petFolder.Name)
        local radius = minRadius + #petFolder:GetChildren()
        local angle = i * (circle / #petFolder:GetChildren()) -- just some math to find where the pets should be placed around the player
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius

        -- local walkJumpAnim = math.max(math.sin(time()*5),-0.1)
        local walkAnim = (math.cos((time()+pet.TimeDelay.Value)*10)/7)/3 -- You can put this in desmos, it is the walk animation that follows a cosin wave, makes it smooth as butter

        local petCFrame : CFrame = pet.PrimaryPart.CFrame:Lerp(character.HumanoidRootPart.CFrame * CFrame.new(x,pet.Configuration.YIndex.Value,z),0.1) -- finding where to actually put the pet

        if character.Humanoid.MoveDirection.Magnitude > 0 then
            petCFrame *= CFrame.Angles(0,0,walkAnim) -- do the animation when not
        else
            pet.PrimaryPart.CFrame = CFrame.lookAt(pet.PrimaryPart.Position,character.HumanoidRootPart.Position) -- look at the player when idle
        end

        pet:PivotTo(petCFrame)
    end
end

function OnClick(pet : table, slot : Frame, data : table) -- Check if the player wants to equip/Unequip a pet or maybe delete, also sets up the petData frame
    
    -- The two if statemets are here because if I don't put them the events remain and it either equips/unequips multiple pets at once or deletes everything. either way not good
    if(connection) then
        connection:Disconnect()
    end

    if (deleteConnection) then
        deleteConnection:Disconnect()
    end

    pDataFrame.Close.MouseButton1Click:Connect(function()
        pDataFrame.Visible = false
        connection:Disconnect()
        return;
    end)

    pDataFrame.Visible = true
    pDataFrame.PetImage.Image = pet.Image
    pDataFrame.Stats.Text = "x"..pet.Multiplier
    pDataFrame.Rarity.Text = pet.Rarity
    pDataFrame.Rarity.BackgroundColor = rarityColors[pet.Rarity]
    pDataFrame.NameText.Text = pet.Name

    if(slot.Equipped.Value) then
        pDataFrame.Equip.Text = "Unequip"
    else
        pDataFrame.Equip.Text = "Equip"
    end

    connection = pDataFrame.Equip.MouseButton1Click:Connect(function()
        onEquip(slot, data)
    end)

    deleteConnection = pDataFrame.Delete.MouseButton1Click:Connect(function()
        deletePet(pet,slot,data)
    end)
end

function onEquip(slot : Frame, data : table)
    local eq : boolean = slot.Equipped.Value

    if(eq == true) then
        --Unequip the pet
        pDataFrame.Equip.Text = "Equip"
        hasEquipped -= 1
        print("unequipped Slot : ".. slot.Name)
        
        petFolder:FindFirstChild(slot.Name:sub(0,-4)):Destroy() -- delete the pet from the equipped folder
        slot.LayoutOrder = 10 -- change the order so that only the equipped pets show up first
        slot.EqIndicator.Visible = false;
        slot.Equipped.Value = false
        
    else
        --Equip the pet    
        if (data.MaxEquipped < hasEquipped + 1)then
            warningAnim("Reached max")
            return;
        end
        hasEquipped += 1
        pDataFrame.Equip.Text = "Unequip"
        print("Equipped slot:".. slot.Name)
        local petToEquip : Model = game.ReplicatedStorage.Pets:FindFirstChild(slot.Name:sub(0,-4),true)

        local clonedPet = petToEquip:Clone()
        clonedPet.Parent = petFolder -- Add the pet to the equipped folder

        local timeDelay = Instance.new("IntValue",clonedPet)
        timeDelay.Name = "TimeDelay"
        timeDelay.Value = math.random(1,10)
        
        slot.LayoutOrder = 0 -- remove the layout order so the pets go back
        slot.EqIndicator.Visible = true;
        slot.Equipped.Value = true
    end
    pEq.Text = hasEquipped.."/"..data.MaxEquipped -- Shows the amount of pets you have equipped
end

function warningAnim(message : string) -- When the player has reached the max amount of allowed pets equipped, a warning is animated to warn the player
    local warningClone = warning:Clone()

    warningClone.Text = message
    warningClone.Parent = backpackGUI
    warningClone.Position = warning.Position
    warningClone.AnchorPoint = Vector2.new(0.5, 0.5)

    local tweenInfo = TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.In)
    local tween = ts:Create(warningClone,tweenInfo,{Position = UDim2.new(0.5,0,0.5,0)})

    tween:Play()
    task.wait(1)
    local tween2 = ts:Create(warningClone,tweenInfo,{Position = UDim2.new(0.5,0,2,0)})
    tween2:play()
    task.wait(1)
    warningClone:Destroy()
end

function deletePet(pet : table, slot : ImageButton, data : table)
    -- Deletes the pet from the backpack (client)
    local petToDelete = workspace.PlayerEggs[char.Name]:FindFirstChild(pet.Name)

    if(petToDelete) then
        petToDelete:Destroy()
        hasEquipped -= 1
    end

    petFrame:FindFirstChild(slot.Name):Destroy()
    pDataFrame.Visible = false

    -- Deletes the pet from the player's data (server)
    local event : RemoteEvent = game.ReplicatedStorage.Connection.Egg.deletePet
    event:FireServer(pet)
    
    pEq.Text = hasEquipped.."/"..data.MaxEquipped
end