SWEP.Base = "weapon_tttbase"

SWEP.ViewModel  = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/dav0r/camera.mdl"

SWEP.Kind = WEAPON_EQUIP2
SWEP.AutoSpawnable = false
SWEP.CanBuy = { ROLE_DETECTIVE }
SWEP.LimitedStock = true

function SWEP:Initialize()
    self:SetModelScale(0.75)
    self:SetHoldType("camera")
end
