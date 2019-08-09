ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = ""
ENT.Author = "Loures"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.IsReady = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Welded")
	self:NetworkVar("Entity", 0, "Player")
	self:NetworkVar("Bool", 1, "ShouldPitch")
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
	--self:SetPlayer(Entity(1))
	--self:SetWelded(true)
	timer.Simple(0, function() self:GetPhysicsObject():SetMass(25) end)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self.HP = 80 --you can change this to your likings
	end
end
