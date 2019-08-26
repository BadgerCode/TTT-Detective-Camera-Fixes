-- TODO: Make hook names more unique

hook.Remove("SetupPlayerVisibility", "visleaf_detective_camera_badger")
hook.Add("SetupPlayerVisibility", "visleaf_detective_camera_badger", function()
    for k, v in ipairs(ents.FindByClass("ttt_detective_camera_badger")) do
        AddOriginToPVS(v:GetPos() + v:GetAngles():Forward() * 3)
    end
end)

hook.Remove("SetupMove", "rotate_camera_detective_camera_badger")
hook.Add("SetupMove", "rotate_camera_detective_camera_badger", function(ply, mv)
    for _, v in ipairs(ents.FindByClass("ttt_detective_camera_badger")) do -- TODO: More unique entity name?
        if v.IsReady and IsValid(v:GetPlayer()) and v:GetPlayer() == ply and v:GetShouldPitch() and ply:Alive() then
            local ang = v:GetAngles()
            ang:RotateAroundAxis(ang:Right(), ply:GetCurrentCommand():GetMouseY() * -.15)
            ang.p = math.Clamp(ang.p, -75, 75)
            ang.r = 0
            ang.y = v.OriginalY
            v:SetAngles(ang)
        end
    end
end)



-- TODO: Shared?

hook.Remove("PlayerSwitchWeapon", "weapon_switch_detective_camera_badger")
hook.Add("PlayerSwitchWeapon", "weapon_switch_detective_camera_badger", function(ply)
    for _, v in ipairs(ents.FindByClass("ttt_detective_camera_badger")) do -- TODO: More unique entity name?
        if v.IsReady and IsValid(v:GetPlayer()) and v:GetPlayer() == ply and v:GetShouldPitch() and ply:Alive() then
            return true
        end
    end
end)

hook.Remove("ShouldCollide", "collisions_detective_camera_badger")
hook.Add("ShouldCollide", "collisions_detective_camera_badger", function(e1, e2)
    if e1:IsPlayer() and e2:GetClass() == "ttt_detective_camera_badger" then return true end
    if e2:IsPlayer() and e1:GetClass() == "ttt_detective_camera_badger" then return true end
end)
