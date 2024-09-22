
if SERVER then
    AddCSLuaFile("client/cool_hud.lua")

    util.AddNetworkString("noct_spwn")

    hook.Add("PlayerSpawn", "flf_noct_ispwn", function( ply ) -- updates the player when spawning, allows for updating mid server runtime
    
        net.Start("noct_spwn")
            net.WriteFloat(WUMA.Limits[ply:GetUserGroup() .. "_props"].limit or 0)
            net.WriteFloat(WUMA.Limits[ply:GetUserGroup() .. "_sents"].limit or 0)
        net.Send(ply)
    
    end)

    if true then -- for development and testing
        net.Start("noct_spwn")
            net.WriteFloat(WUMA.Limits[Entity(1):GetUserGroup() .. "_props"].limit or 0)
            net.WriteFloat(WUMA.Limits[Entity(1):GetUserGroup() .. "_sents"].limit or 0)
        net.Send(Entity(1))
    end
end

if CLIENT then
    include("client/cool_hud.lua")

    FLF_TOG = {
        enabled = true,
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

