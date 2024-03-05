local module = {}

local player : Player = script.Parent.Parent.Parent.Parent
local char : Model = player.Character or player.CharacterAdded:Wait();
local petFolder : Folder = char:WaitForChild("PetsEquipped")

local  playerGui = player.PlayerGui

local backpackGUI : ScreenGui = playerGui:WaitForChild("BackpackGUI")
local bFrame : Frame = backpackGUI:FindFirstChild("BackpackFrame")
local petFrame : ScrollingFrame = bFrame:FindFirstChild("PetFrame")
local petSlot : Frame = script:FindFirstChild("PetSlot")
local girdLayout : UIGridLayout = petFrame.UIGridLayout

function module.openCloseBackpack()
    bFrame.Visible = not bFrame.Visible;
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

function module.PositionPets()
    for i,pet in petFolder:GetChildren() do
        local radius = minRadius + #petFolder:GetChildren()
        local angle = i * (circle / #petFolder:GetChildren())
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius

        -- local walkJumpAnim = math.max(math.sin(time()*5),-0.1)
        local walkAnim = (math.cos(time()*10)/7)/3

        local petCFrame : CFrame = pet.PrimaryPart.CFrame:Lerp(char.HumanoidRootPart.CFrame * CFrame.new(x,-pet.Configuration.YIndex.Value,z),0.1)

        if char.Humanoid.MoveDirection.Magnitude > 0 then
            petCFrame *= CFrame.Angles(0,0,walkAnim)
        else
            pet.PrimaryPart.CFrame = CFrame.lookAt(pet.PrimaryPart.Position,char.HumanoidRootPart.Position)
        end

        pet:PivotTo(petCFrame)
    end

end

function module.onEquip(slot : Frame)
    local eq : boolean = slot.Equipped.Value

    if(eq == true) then
        --Unequip the pet
        
        petFolder:FindFirstChild(slot.Name):Destroy()
        slot.LayoutOrder = 10
        slot.EqIndicator.Visible = false;
        slot.Equipped.Value = false
    else
        --Equip the pet    
        local petToEquip : Folder = game.ReplicatedStorage.Pets:FindFirstChild(slot.Name,true)
        petToEquip:Clone().Parent = petFolder
        slot.LayoutOrder = -1
        slot.EqIndicator.Visible = true;
        slot.Equipped.Value = true
    end

end

return module;