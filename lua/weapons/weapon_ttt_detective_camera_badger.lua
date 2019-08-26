-- Detective Equipment: Placeable camera
AddCSLuaFile()

if SERVER then
    resource.AddFile("materials/vgui/ttt/icon_badger_camera.vmt")
    resource.AddFile("materials/tttcamera/cameranoise.vmt")
end

SWEP.Author = "Select (Justin Back) and Badger"
SWEP.Contact = "http://steamcommunity.com/profiles/76561198021181972"

if CLIENT then
    SWEP.PrintName = "Camera"
    SWEP.Slot = 7
    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 10
    SWEP.DrawCrosshair = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "Camera",
        desc = "MOUSE1 to place.\nUse this to watch an area of the map."
    }

    SWEP.Icon = "vgui/ttt/icon_badger_camera"
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = true
SWEP.AutoSpawnable = false
-- 
-- View/World models
SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel = Model("models/dav0r/camera.mdl")

function SWEP:Initialize()
    self:SetModelScale(0.75)
    self:SetHoldType("camera")
end

if SERVER then
    function SWEP:PrimaryAttack()
        if not IsFirstTimePredicted() then return end

        local tr = util.TraceLine({
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
            filter = self.Owner
        })

        if IsValid(self.camera) and self.camera:GetShouldPitch() then
            self.camera:SetShouldPitch(false)
            self:Remove()
            -- Placement confirmed
        end

        if tr.HitWorld and not self.camera then
            local camera = ents.Create("ttt_detective_camera_badger")
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
            -- When first placed
        end

        self:RemoveExistingCameras()
    end

    function SWEP:RemoveExistingCameras()
        for _, v in ipairs(ents.FindByClass("ttt_detective_camera_badger")) do
            if v:GetPlayer() == self.Owner and v ~= self.camera then
                v:Remove()
            end
        end
    end
end

if CLIENT then
    function SWEP:Deploy()
        self.Owner:DrawViewModel(false)

        return true
    end

    function SWEP:OnRemove()
        self.Owner:ConCommand("lastinv")
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
end
