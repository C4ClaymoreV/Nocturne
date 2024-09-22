
if SERVER then
    AddCSLuaFile("client/cool_hud.lua")

    util.AddNetworkString("noct_spwn")

    hook.Add("PlayerSpawn", "flf_noct_ispwn", function( ply ) -- updates the player when spawning, allows for updating mid server runtime
    
        net.Start("noct_spwn")
            net.WriteFloat(WUMA.Limits[ply:GetUserGroup() .. "_props"].limit or 0)
            net.WriteFloat(WUMA.Limits[ply:GetUserGroup() .. "_sents"].limit or 0)
        net.Send(ply)
    
    end)

    if false then -- for development and testing
        net.Start("noct_spwn")
            net.WriteFloat(WUMA.Limits[Entity(1):GetUserGroup() .. "_props"].limit or 0)
            net.WriteFloat(WUMA.Limits[Entity(1):GetUserGroup() .. "_sents"].limit or 0)
        net.Send(Entity(1))
    end
end

if CLIENT then
    include("client/cool_hud.lua")
    if not file.Exists("nocturne/", "DATA") then
        file.CreateDir("nocturne")
    end
    if not file.Exists("nocturne/hud.txt", "DATA") then

        FLF_TOG = {
            hud = true,
            avatar = true,
            playtime = true,
            rank = true,
            props = true,
            sents = true,
            servername = true,
            localtime = true,
            uptime = true,
        }

        file.Write("nocturne/hud.txt", util.TableToJSON(FLF_TOG))

    end

    local json = file.Read("nocturne/hud.txt", "DATA")

    FLF_TOG = util.JSONToTable(json)

    local function SimpleAutoComplete( cmd, args, ... )
        local possibleArgs = { ... }
        local autoCompletes = {}
    
        --TODO: Handle "test test" "test test" type arguments
        local arg = string.Split( args:TrimLeft(), " " )
    
        local lastItem = nil
        for i, str in pairs( arg ) do
            if ( str == "" && ( lastItem && lastItem == "" ) ) then table.remove( arg, i ) end
            lastItem = str
        end -- Remove empty entries. Can this be done better?
    
        local numArgs = #arg
        local lastArg = table.remove( arg, numArgs )
        local prevArgs = table.concat( arg, " " )
        if ( #prevArgs > 0 ) then prevArgs = " " .. prevArgs end
    
        local possibilities = possibleArgs[ numArgs ] or { lastArg }
        for _, acStr in pairs( possibilities ) do
            if ( !acStr:StartsWith( lastArg ) ) then continue end
            table.insert( autoCompletes, cmd .. prevArgs .. " " .. acStr )
        end
            
        return autoCompletes
    end

    concommand.Add( "noct_hud_set", function( ply, cmd, args )

        local bool = args[2] == "true"
        if !bool and args[2] ~= "false" then
            print("modules can only be set true or false")
            return
        end

        if FLF_TOG[args[1]] ~= nil then
            FLF_TOG[args[1]] = bool
            file.Write("nocturne/hud.txt", util.TableToJSON(FLF_TOG))
            
            local status = "Disabled"
            if bool then status = "Enabled" end
            print(args[1] .. " has been " .. status)
        else 
            print("Invalid Table Index Given") 
        end

    end, 
        function( cmd, args )
        return SimpleAutoComplete( cmd, args, table.GetKeys(FLF_TOG), { "true", "false" }  )
    end)

end

