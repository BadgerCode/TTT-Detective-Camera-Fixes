-- Detective Equipment: Placeable camera
AddCSLuaFile()


ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = ""
ENT.Author = "Loures and Badger"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.IsReady = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Welded")
	self:NetworkVar("Entity", 0, "Player")
	self:NetworkVar("Bool", 1, "PitchingModeEnabled")
	self.IsReady = true
end

function ENT:Initialize()
	self.CanPickup = false
	self:SetModel("models/dav0r/camera.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:DrawShadow(false)
	self:SetModelScale(.33, 0)
	self:Activate()
	self.OriginalY = self:GetAngles().y

	timer.Simple(0, function() self:GetPhysicsObject():SetMass(25) end)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self.HP = 80
	end
end



if SERVER then
    util.AddNetworkString("Badger_TTTCameraDetach")
    util.AddNetworkString("Badger_TTTCameraPickedUp")

    function ENT:Use(user)
        if self:GetWelded() and user != self:GetPlayer() then return end

        self:Remove()

        if !self:GetPitchingModeEnabled() then
            user:Give("weapon_ttt_detective_camera_badger")
        end

        net.Start("Badger_TTTCameraPickedUp")
        net.Send(user)
    end

    function ENT:OnTakeDamage(dmginfo)
        if self:GetPitchingModeEnabled() then return end
        if IsValid(dmginfo:GetAttacker())
            and dmginfo:GetAttacker():IsPlayer()
            and dmginfo:GetAttacker():IsSpec() then return end

        if dmginfo:GetDamageType() ~= DMG_BURN and self:GetWelded() then
            if IsValid(self:GetPlayer()) then
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
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end