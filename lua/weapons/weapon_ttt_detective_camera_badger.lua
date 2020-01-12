-- Detective Equipment: Weapon to place cameras
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

function SWEP:SetupDataTables()
    self:NetworkVar("Entity", 0, "Camera")
end

function SWEP:CameraIsPlaced()
    return IsValid(self:GetCamera())
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    if SERVER then
        if !self:CameraIsPlaced() then
            local tr = util.TraceLine({
                start = self.Owner:GetShootPos(),
                endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
                filter = self.Owner
            })

            if tr.HitWorld then
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

                camera:SetPitchingModeEnabled(true)
                self:SetCamera(camera)
                self:SetHoldType("magic")

                hook.Call("TTTEquipmentUse", nil, self.Owner, self, "Camera placed") -- TODO: Translate
            end
        else
            if self:GetCamera():GetPitchingModeEnabled() then
                self:GetCamera():SetPitchingModeEnabled(false)
                self:SetNextPrimaryFire(CurTime() + 1)

                timer.Simple(0.5, function()
                    self:Remove()
                end)
            end
        end

        self:RemoveExistingCameras()
    end
end

function SWEP:Deploy()
    if SERVER and IsValid(self:GetOwner()) then
        self:GetOwner():DrawViewModel(false)
    end

    return true
end

function SWEP:OnRemove()
    if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
        RunConsoleCommand("lastinv")
    end
end

if SERVER then
    function SWEP:RemoveExistingCameras()
        for _, v in ipairs(ents.FindByClass("ttt_detective_camera_badger")) do
            if v:GetPlayer() == self.Owner and v ~= self:GetCamera() then
                v:Remove()
            end
        end
    end
end

if CLIENT then
    -- HUD properties
    local font = "CloseCaption_Normal"
    local pitchText = "MOVE THE MOUSE UP AND DOWN TO PITCH THE CAMERA"
    local placementText = "PRESS MOUSE1 TO PLACE THE CAMERA"
    -- Get HUD text sizxe
    surface.SetFont(font)
    local pitchTextWidth, pitchTextHeight = surface.GetTextSize(pitchText)
    local placementTextWidth, placementTextHeight = surface.GetTextSize(placementText)

    function SWEP:DrawHUD()
        if self:CameraIsPlaced() == false then
            local padding = 10
            local textTopLeft = Vector(ScrW() / 2 - placementTextWidth / 2, ScrH() / 2 + 50, 0)
            surface.SetDrawColor(0, 0, 0, 220)
            surface.DrawRect(textTopLeft.x - padding, textTopLeft.y - padding, placementTextWidth + padding + padding, placementTextHeight + padding + padding)
            surface.SetFont(font)
            surface.SetTextColor(Color(228, 199, 7, 255))
            surface.SetTextPos(textTopLeft.x, textTopLeft.y)
            surface.DrawText(placementText)
        else
            local padding = 10
            local textTopLeft = Vector(ScrW() / 2 - pitchTextWidth / 2, ScrH() / 2 + 50, 0)
            surface.SetDrawColor(0, 0, 0, 220)
            surface.DrawRect(textTopLeft.x - padding, textTopLeft.y - padding, pitchTextWidth + padding + padding, pitchTextHeight + padding + padding)
            surface.SetFont(font)
            surface.SetTextColor(Color(228, 199, 7, 255))
            surface.SetTextPos(textTopLeft.x, textTopLeft.y)
            surface.DrawText(pitchText)
        end
    end

    function SWEP:DrawWorldModel()
        local isEquipped = IsValid(self.Owner)

        if isEquipped then
            if self:CameraIsPlaced() then return end
            self:DrawHeldWorldModel()
        else
            self:DrawModel()
        end
    end

    function SWEP:DrawHeldWorldModel()
        local rightHandBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if rightHandBone == nil then return end
        local rightHandPos, rightHandAngle = self.Owner:GetBonePosition(rightHandBone)
        rightHandPos = rightHandPos + rightHandAngle:Forward() * 6.97 + rightHandAngle:Up() * -4.34 + rightHandAngle:Right() * 2.2

        if not IsValid(self.CustomWorldModel) then
            -- Ideally, this should be drawing the actual world model in the player's hand
            -- Couldn't get it to work so here's a clientside model instead
            self.CustomWorldModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
            self.CustomWorldModel:SetModelScale(0.55)
        end

        local modelSettings = {
            model = self.WorldModel,
            pos = rightHandPos,
            angle = self.Owner:EyeAngles()
        }

        render.Model(modelSettings, self.CustomWorldModel)
    end
end