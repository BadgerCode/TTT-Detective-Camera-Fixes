hook.Remove("CreateMove", "rotate_client_detective_camera_badger")
hook.Add("CreateMove", "rotate_client_detective_camera_badger", function(cmd)
    for _, v in ipairs(ents.FindByClass("ttt_detective_camera_badger")) do
        if v.IsReady and IsValid(v:GetPlayer()) and v:GetPlayer() == LocalPlayer() and v:GetPitchingModeEnabled() and LocalPlayer():Alive() then
            local ang = (v:GetPos() - LocalPlayer():EyePos()):Angle()
            local ang2 = Angle(math.NormalizeAngle(ang.p), math.NormalizeAngle(ang.y), math.NormalizeAngle(ang.r))
            cmd:SetViewAngles(ang2)
            cmd:ClearMovement()
        end
    end
end)


-- TODO: Fix thirdperson/IN_CAMERA issues.
-- Issue 1: The player's flashlight attaches to their weapon
    -- For the crowbar, this makes the flashlight shine away from where the player is looking
-- Issue 2: Reload sounds stop working
hook.Remove("ShouldDrawLocalPlayer", "drawlocalplayer_detective_camera_badger")
hook.Add("ShouldDrawLocalPlayer", "drawlocalplayer_detective_camera_badger", function(ply)
    return IN_CAMERA
end)