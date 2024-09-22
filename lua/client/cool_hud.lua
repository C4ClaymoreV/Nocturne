
local function sw( width )
    return (width / 1920) * ScrW()
end

local function sh( height )
    return (height / 1080) * ScrH()
end

local function timeToStr( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = math.floor( tmp / 24 )

	return string.format( "%02ih %02im %02is", h, m, s )
end

net.Receive("noct_spwn", function()

    local PMax = net.ReadTable() -- max props
    local SMax = net.ReadTable() -- max sents
    local PANEL = {}
    function PANEL:Init()
        self:SetText( "" )
    end
    function PANEL:Paint() 
        surface.SetDrawColor(Color(36, 36, 36, 214))
        surface.DrawTexturedRect( 0, 0, ScrW(), sh(32) )
        surface.SetDrawColor(Color(65, 211, 255))
        surface.DrawRect(0, sh(30), ScrW(), sh(2))
    end
    vgui.Register( "flf_topb", PANEL, "DLabel" )

    -- foreground
    local PANEL = {}
    function PANEL:Init()
        self:SetText( "" )
    end
    function PANEL:Paint() 

        local width = 2

        if FLF_TOG.avatar then
            surface.SetDrawColor(Color(65, 211, 255))
            surface.DrawRect( sw(width), sw(2), sw(24), sw(24) )
            width = width + 28
        end

        if FLF_TOG.playtime then
            surface.SetDrawColor(Color(36, 36, 36, 100)) -- background define
            surface.SetFont("TargetIDSmall")
            local ptw = surface.GetTextSize("play time: ")
            surface.SetFont("TargetID")
            local str = timeToStr(LocalPlayer():GetUTimeTotalTime())
            local tmw = surface.GetTextSize(str)
            surface.DrawRect( sw(width - 2), sh(2), ptw + tmw + sw(4), sh(28) )

            surface.SetTextColor(Color(148, 148, 148))
            surface.SetTextPos(sw(width), sh(16))
            surface.SetFont("TargetIDSmall")
            surface.DrawText("play time: ")

            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(sw(width) + ptw, sh(12))
            surface.SetFont("TargetID")
            surface.DrawText(str)
            

            width = width + ((ptw + tmw) / ScrW() * 1920) + 6 -- due to text scaling
        end

        if FLF_TOG.rank then
            local rstr = "rank: "
            local rank = LocalPlayer():Team()
            local rnkName = team.GetName(rank)
            local rnkCol = team.GetColor(rank)

            surface.SetFont("TargetIDSmall")
            local rsw = surface.GetTextSize(rstr)

            surface.SetFont("TargetID")
            local rrw = surface.GetTextSize(rnkName)

            surface.SetDrawColor(Color(36, 36, 36, 100))
            surface.DrawRect( sw(width - 2), sh(2), rsw + rrw + sw(8), sh(28) )

            surface.SetTextColor(Color(148, 148, 148))
            surface.SetTextPos(sw(width), sh(16))
            surface.SetFont("TargetIDSmall")
            surface.DrawText(rstr)

            surface.SetTextColor(rnkCol)
            surface.SetTextPos(sw(width + 2) + rsw , sh(12))
            surface.SetFont("TargetID")
            surface.DrawText(rnkName)
            width = width + ((rsw + rrw) / ScrW() * 1920) + 10
        end

        if FLF_TOG.props then
            local pstr = "props: "
            local pcnt = LocalPlayer():GetCount( "props" ) .. "/" .. PMax[LocalPlayer():GetUserGroup()]

            surface.SetFont("TargetIDSmall")
            local psw = surface.GetTextSize(pstr)

            surface.SetFont("TargetID")
            local pcw = surface.GetTextSize(pcnt)
            surface.SetDrawColor(Color(36, 36, 36, 100))
            surface.DrawRect( sw(width - 2), sh(2), psw + pcw + sw(8), sh(28) )

            surface.SetTextColor(Color(148, 148, 148))
            surface.SetTextPos(sw(width), sh(16))
            surface.SetFont("TargetIDSmall")
            surface.DrawText(pstr)

            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(sw(width + 2) + psw , sh(12))
            surface.SetFont("TargetID")
            surface.DrawText(pcnt)
            width = width + ((psw + pcw) / ScrW() * 1920) + 10
        end

        if FLF_TOG.sents then
            local sstr = "sents: "
            local scnt = LocalPlayer():GetCount( "sents" ) .. "/" .. SMax[LocalPlayer():GetUserGroup()]

            surface.SetFont("TargetIDSmall")
            local ssw = surface.GetTextSize(sstr)

            surface.SetFont("TargetID")
            local scw = surface.GetTextSize(scnt)
            surface.SetDrawColor(Color(36, 36, 36, 100))
            surface.DrawRect( sw(width - 2), sh(2), ssw + scw + sw(8), sh(28) )

            surface.SetTextColor(Color(148, 148, 148))
            surface.SetTextPos(sw(width), sh(16))
            surface.SetFont("TargetIDSmall")
            surface.DrawText(sstr)

            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(sw(width + 2) + ssw , sh(12))
            surface.SetFont("TargetID")
            surface.DrawText(scnt)
            width = width + ((ssw + scw) / ScrW() * 1920) + 8
        end

        -- center

        if FLF_TOG.servername then
            local sstr = GetHostName()
            surface.SetFont("HudDefault")
            local snw = surface.GetTextSize(sstr)

            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(ScrW()/2 - snw/2, sh(8))
            surface.SetFont("HudDefault")
            surface.DrawText(sstr)
        end


        -- left
        local width = 0

        if FLF_TOG.localtime then
            local tstr = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
            surface.SetFont("TargetID")
            local tsw = surface.GetTextSize(tstr)

            local refpoint = ScrW() - tsw - sw(width + 4)
            surface.SetDrawColor(Color(36, 36, 36, 100))
            surface.DrawRect( refpoint, sh(2), tsw + sw(8), sh(28) )

            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos( refpoint + sw(2), sh(12))
            surface.DrawText(tstr)

            width = width + ((tsw) / ScrW() * 1920) + 8
        end

        if FLF_TOG.uptime then
            local upstr = "UpTime: "
            local uptime = "" .. timeToStr(math.floor(RealTime())) -- turn to string

            surface.SetFont("TargetIDSmall")
            local usw = surface.GetTextSize(upstr)

            surface.SetFont("TargetID")
            local pcw = surface.GetTextSize(uptime)

            local refpoint = ScrW() - usw - pcw - sw(width + 6)
            surface.SetDrawColor(Color(36, 36, 36, 100))
            surface.DrawRect( refpoint, sh(2), usw + pcw + sw(8), sh(28) )

            surface.SetTextColor(Color(148, 148, 148))
            surface.SetTextPos( refpoint + sw(2), sh(16))
            surface.SetFont("TargetIDSmall")
            surface.DrawText(upstr)

            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(refpoint + sw(2) + usw , sh(12))
            surface.SetFont("TargetID")
            surface.DrawText(uptime)

            width = width + ((usw + pcw) / ScrW() * 1920) + 8
        end

    end
    vgui.Register( "flf_top", PANEL, "DLabel" )
    
    
    local topb = vgui.Create("flf_topb")
    topb:SetSize( sw(1920), sh(32) )
    topb:SetPaintedManually( true )

    local top = vgui.Create("flf_top")
    top:SetSize( sw(1920), sh(32) )
    top:SetPaintedManually( true )

    if FLF_TOG.avatar then 
        local Avatar = vgui.Create( "AvatarImage", top )
            Avatar:SetSize( sw(22), sw(22) )
            Avatar:SetPos( sw(3) , sw(3) )
            Avatar:SetPlayer( LocalPlayer(), 64 )
    end

    hook.Add("HUDPaintBackground", "flf_noct_hudb", function()

        topb:PaintManual()
        
    end)

    hook.Add("HUDPaint", "flf_noct_hud", function()

        top:PaintManual()
        
    end)
end)
