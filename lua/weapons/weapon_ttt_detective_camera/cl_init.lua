include("shared.lua")

SWEP.PrintName = "Camera"
SWEP.Slot      = 7 

SWEP.ViewModelFOV  = 10
SWEP.ViewModelFlip = false
SWEP.Icon = "vgui/ttt/icon_loures_camera"

SWEP.EquipMenuData = {
  type = "item_weapon",
  name = "Camera",
  desc = "Use this to watch people get killed live\nMOUSE1 to place"
}

function SWEP:PrimaryAttack()
	self.DrawInstructions = true
	RENDER_CONNECTION_LOST = false
end

function SWEP:Deploy()
	if IsValid(self.Owner) then
		self.Owner:DrawViewModel(false)
	end
	return true
end

function SWEP:DrawWorldModel()
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:ConCommand("lastinv")
	end
end

surface.SetFont("TabLarge")
local w = surface.GetTextSize("MOVE THE MOUSE UP AND DOWN TO PITCH THE CAMERA")

function SWEP:DrawHUD()
	if self.DrawInstructions then
		surface.SetFont("TabLarge")
		surface.SetTextColor(Color(50, 60, 200, 255))
		surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() / 2 + 50)
		surface.DrawText("MOVE THE MOUSE UP AND DOWN TO PITCH THE CAMERA")
	end
end

net.Receive("TTTCamera.Instructions", function()
	local p = LocalPlayer()
	if p.GetWeapon and IsValid(p:GetWeapon("weapon_ttt_detective_camera")) then
		p:GetWeapon("weapon_ttt_detective_camera").DrawInstructions = false
	end
end)