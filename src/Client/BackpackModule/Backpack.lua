 local module = {}

local ts = game:GetService("TweenService")

local player : Player = script.Parent.Parent.Parent.Parent
local char : Model = player.Character or player.CharacterAdded:Wait();
local petFolder = workspace:FindFirstChild("PlayerEggs"):FindFirstChild("deadgamer323")

local  playerGui = player.PlayerGui

local backpackGUI : ScreenGui = playerGui:WaitForChild("BackpackGUI")
local bFrame : Frame = backpackGUI:FindFirstChild("BackpackFrame")
local petFrame : ScrollingFrame = bFrame:FindFirstChild("PetFrame")
local petSlot : Frame = script:FindFirstChild("PetSlot")
local warning : TextLabel = backpackGUI:FindFirstChild("Warning")
local eFrame : Frame = bFrame:FindFirstChild("EquippedFrame")
local pEq : TextLabel = eFrame:FindFirstChild("PetsEquipped")

local pDataFrame : Frame = backpackGUI:FindFirstChild("PetData")

function module.openCloseBackpack()
    local openOrClosed = bFrame.Visible
    bFrame.Visible = not bFrame.Visible;
    
    if(openOrClosed) then
        pDataFrame.Visible = false
    end
end

function module.AddPet(pet : table)
    local petSlotClone : Frame = petSlot:Clone()
    petSlotClone.ImageLabel.Image = pet.Image
    petSlotClone.Name = pet.Name
    petSlotClone.Parent = petFrame
    petSlotClone.LayoutOrder = 10
end

local circle = math.pi * 2
local minRadius = 4

function module.PositionPets(petFolder : Folder)
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

local rarityColors = {
    Common = BrickColor.new(211,211,211);
}
local hasEquipped = 0
local connection
function module.OnClick(pet : table, slot : Frame, data : table)
    if(connection) then
        connection:Disconnect()
    end

    pDataFrame.Close.MouseButton1Click:Connect(function()
        pDataFrame.Visible = false
        connection:Disconnect()
        return;
    end)

    pDataFrame.Visible = true
    pDataFrame.PetImage.Image = pet.Image
    pDataFrame.Stats.Text = pet.Multiplier
    pDataFrame.Rarity.Text = pet.Rarity
    pDataFrame.Rarity.BackgroundColor = rarityColors[pet.Rarity]
    pDataFrame.NameText.Text = pet.Name

    if(slot.Equipped.Value) then
        pDataFrame.Equip.Text = "Unequip"
    else
        pDataFrame.Equip.Text = "Equip"
    end

    connection = pDataFrame.Equip.MouseButton1Click:Connect(function()
        module.onEquip(slot, data)
    end)
end

function module.onEquip(slot : Frame, data : table)
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

function warningAnim(message : string)
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

return module;