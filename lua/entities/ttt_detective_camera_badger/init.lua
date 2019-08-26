AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("Badger_TTTCameraDetach")
util.AddNetworkString("Badger_TTTCameraPickedUp")

function ENT:Use(user)
	if user:IsDetective() and user == self:GetPlayer() then
		self:Remove()
		if !self:GetShouldPitch() then
			user:Give("weapon_ttt_detective_camera_badger")
		else
			user:GetWeapon("weapon_ttt_detective_camera_badger").camera:SetShouldPitch(false)
			user:GetWeapon("weapon_ttt_detective_camera_badger").camera:Remove()
		end

		net.Start("Badger_TTTCameraPickedUp")
		net.Send(user)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetShouldPitch() then return end
	if dmginfo:GetDamageType() ~= DMG_BURN then
		if IsValid(self:GetPlayer()) and self:GetWelded() then
			net.Start("Badger_TTTCameraDetach")
			net.Send(self:GetPlayer())
		end
		constraint.RemoveAll(self)
		self:SetWelded(false)
		self:TakePhysicsDamage(dmginfo)
	end
	self.HP = self.HP - dmginfo:GetDamage()
	if self.HP <= 0 then
		local ed = EffectData()
		ed:SetStart(self:GetPos()) 
		ed:SetOrigin(self:GetPos())
		ed:SetScale(0.25)
		util.Effect("HelicopterMegaBomb", ed)
		self:Remove()
	end
end