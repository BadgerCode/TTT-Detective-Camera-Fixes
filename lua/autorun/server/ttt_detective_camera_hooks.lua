-- TODO: Make hook names more unique

hook.Remove("TTTCamera.VISLEAF")
hook.Add("SetupPlayerVisibility", "TTTCamera.VISLEAF", function()
    for k, v in ipairs(ents.FindByClass("ttt_detective_camera")) do
        AddOriginToPVS(v:GetPos() + v:GetAngles():Forward() * 3)
    end
end)

hook.Remove("TTTCamera.Rotate")
hook.Add("SetupMove", "TTTCamera.Rotate", function(ply, mv)
    for _, v in ipairs(ents.FindByClass("ttt_detective_camera")) do -- TODO: More unique entity name?
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

hook.Remove("TTTCamera.RotateNoSwitch")
hook.Add("PlayerSwitchWeapon", "TTTCamera.RotateNoSwitch", function(ply)
    for _, v in ipairs(ents.FindByClass("ttt_detective_camera")) do -- TODO: More unique entity name?
        if v.IsReady and IsValid(v:GetPlayer()) and v:GetPlayer() == ply and v:GetShouldPitch() and ply:Alive() then
            return true
        end
    end
end)

hook.Remove("TTTCamera.Collide")
hook.Add("ShouldCollide", "TTTCamera.Collide", function(e1, e2)
    if e1:IsPlayer() and e2:GetClass() == "ttt_detective_camera" then return true end
    if e2:IsPlayer() and e1:GetClass() == "ttt_detective_camera" then return true end
end)
