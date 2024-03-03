local module = {}

local player : Player = script.Parent.Parent.Parent.Parent

local backpackGUI : ScreenGui = player.PlayerGui.BackpackGUI
local bFrame : Frame = backpackGUI:FindFirstChild("BackpackFrame")
local petFrame : ScrollingFrame = bFrame:FindFirstChild("PetFrame")
local petSlot : Frame = script:FindFirstAncestor("PetSlot")
local girdLayout : UIGridLayout = petFrame.UIGridLayout

function module.openCloseBackpack()
    petFrame.Visible = not petFrame.Visible;
end

function module.AddPet(pet : table)
    local petSlotClone : Frame = petSlot:Clone()
    petSlotClone.ImageLabel.Image = pet.Image
    petSlotClone.Name = pet.Name
    petSlotClone.Parent = petFrame
    petSlotClone.LayoutOrder = 10
end

function module.onClick(slot : Frame)
    local eq : boolean = slot.Equipped.Value

    if(eq == true) then
        --Unequip the pet
        slot.LayoutOrder = 10
        slot.Equipped.Value = false
    else
        --Equip the pet    
        slot.LayoutOrder = -1
        slot.Equipped.Value = true
    end

end

return module;