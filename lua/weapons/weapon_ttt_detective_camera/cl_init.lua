include("shared.lua")
SWEP.PrintName = "Camera"
SWEP.Slot = 7
SWEP.ViewModelFOV = 10
SWEP.ViewModelFlip = false
SWEP.Icon = "vgui/ttt/icon_loures_camera"

SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Camera",
    desc = "MOUSE1 to place.\nUse this to watch an area of the map."
}

function SWEP:Deploy()
    if IsValid(self.Owner) then
        self.Owner:DrawViewModel(false)
    end

    return true
end

function SWEP:OnRemove()
    if IsValid(self.Owner) then
        self.Owner:ConCommand("lastinv")
    end
end



local font = "CloseCaption_Normal"
local pitchText = "MOVE THE MOUSE UP AND DOWN TO PITCH THE CAMERA"

surface.SetFont(font)
local textWidth, textHeight = surface.GetTextSize(pitchText)

function SWEP:DrawHUD()
    local drawPivotText = true

    if drawPivotText then
        local padding = 10
        local textTopLeft = Vector(ScrW() / 2 - textWidth / 2, ScrH() / 2 + 50, 0)

        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(textTopLeft.x - padding, textTopLeft.y - padding, textWidth + padding + padding, textHeight + padding + padding)

        surface.SetFont(font)
        surface.SetTextColor(Color(228, 199, 7, 255))
        surface.SetTextPos(textTopLeft.x, textTopLeft.y)
        surface.DrawText(pitchText)
    end
end
