
if SERVER then
    AddCSLuaFile("client/cool_hud.lua")

    util.AddNetworkString("noct_spwn")

    hook.Add("PlayerSpawn", "flf_noct_ispwn", function( ply ) -- updates the player when spawning, allows for updating mid server runtime
    
        net.Start("noct_spwn")
            net.WriteTable(URS.limits.prop)
            net.WriteTable(URS.limits.sent)
        net.Send(ply)
    
    end)

    if false then -- for development and testing
        net.Start("noct_spwn")
            net.WriteTable(URS.limits.prop)
            net.WriteTable(URS.limits.sent)
        net.Send(Entity(1))
    end
end

if CLIENT then
    include("client/cool_hud.lua")

    FLF_TOG = {
        avatar = true,
        playtime = true,
        rank = true,
        props = true,
        sents = true,
        servername = true,
        localtime = true,
        uptime = true,
    }

end

