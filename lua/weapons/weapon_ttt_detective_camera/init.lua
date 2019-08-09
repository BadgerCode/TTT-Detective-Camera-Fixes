AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

resource.AddFile("materials/vgui/ttt/icon_loures_camera.vmt")
resource.AddFile("materials/tttcamera/cameranoise.vmt")

function SWEP:Deploy()
	-- self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
end

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() then return end
	local tr = util.TraceLine({start = self.Owner:GetShootPos(), endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100, filter = self.Owner})
	if IsValid(self.camera) and self.camera:GetShouldPitch() then
		self.camera:SetShouldPitch(false)
		self:Remove()
	end
	if tr.HitWorld and !self.camera then
		local camera = ents.Create("ttt_detective_camera_loures")
		camera:SetPlayer(self.Owner)
		camera:SetPos(tr.HitPos - self.Owner:EyeAngles():Forward())
		camera:SetAngles((self.Owner:EyeAngles():Forward() * -1):Angle())
		camera:SetWelded(true)
		camera:Spawn()
		camera:Activate()
		camera:SetPos(tr.HitPos - self.Owner:EyeAngles():Forward())
		camera:SetAngles((self.Owner:EyeAngles():Forward() * -1):Angle())
		timer.Simple(0, function()
		constraint.Weld(camera, tr.Entity, 0, 0, 0, true)
		end)
		camera:SetShouldPitch(true)
		self.camera = camera
	end
	for _, v in ipairs(ents.FindByClass("ttt_detective_camera_loures")) do
		if v:GetPlayer() == self.Owner and v ~= self.camera then
			v:Remove() --if the player already has a camera, remove it
		end
	end
end