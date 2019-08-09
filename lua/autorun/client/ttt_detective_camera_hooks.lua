hook.Remove("CreateMove", "rotate_client_detective_camera_loures")
hook.Add("CreateMove", "rotate_client_detective_camera_loures", function(cmd)
    for _, v in ipairs(ents.FindByClass("ttt_detective_camera_loures")) do
        if v.IsReady and IsValid(v:GetPlayer()) and v:GetPlayer() == LocalPlayer() and v:GetShouldPitch() and LocalPlayer():Alive() then
            local ang = (v:GetPos() - LocalPlayer():EyePos()):Angle()
            local ang2 = Angle(math.NormalizeAngle(ang.p), math.NormalizeAngle(ang.y), math.NormalizeAngle(ang.r))
            cmd:SetViewAngles(ang2)
            cmd:ClearMovement()
        end
    end
end)


-- TODO: This causes the player's flashlight to attach to their weapon
-- For the crowbar, this makes the flashlight shine away from where the player is looking
hook.Remove("ShouldDrawLocalPlayer", "drawlocalplayer_detective_camera_loures")
hook.Add("ShouldDrawLocalPlayer", "drawlocalplayer_detective_camera_loures", function(ply)
    return IN_CAMERA
end)