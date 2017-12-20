if SERVER then
	util.AddNetworkString("TEAM")
	net.Receive("TEAM",function(_,ply)
		local t = net.ReadInt(3)
		teamf.SetTeam(ply,t)
	end)
end


if CLIENT then
	local function CreateFont()
		surface.CreateFont( "BFont", {
			font = "Roboto Cn",
			extended = true,
			size = 60,
			weight = 500,
			antialias = true
		})
	end
	CreateFont()
	function TeamMenu()


		local frame = vgui.Create( "DFrame" )
		frame:SetSize( 400, 200 )
		frame:SetTitle("")
		frame:Center()
		frame:SetBackgroundBlur(true)
		frame:SetSizable(false)
		frame:SetDeleteOnClose(true)
		frame:SetDraggable(false)
		frame:ShowCloseButton(false)
		frame:MakePopup()
		frame.Paint = function()
			if(!GetGlobalBool("Deathmatch"))then
				surface.SetDrawColor( 100, 100, 100, 255 )
				surface.DrawRect(10,(frame:GetTall()/2)-1,frame:GetWide()-20,3)
			end
			surface.SetDrawColor( 110, 110, 110, 255 )
			surface.DrawRect(-4,-4,frame:GetWide()+8,frame:GetTall()+8)
		end

		if(GetGlobalBool("Deathmatch"))then
			local DermaButton = vgui.Create("DButton", frame)
			DermaButton:SetText("Join deathmatch")
			DermaButton:SetFont("BFont")
			DermaButton:SetPos(4, 4)
			DermaButton:SetColor(team.GetColor(3))
			DermaButton:SetSize(frame:GetWide()-8,frame:GetTall()-8)
			DermaButton:SetFGColor(Color(255,255,255,0))
			DermaButton.DoClick = function()
				net.Start("TEAM")
				net.WriteInt(3,3)
				net.SendToServer()
				frame:Close()
			end
			DermaButton.Paint = function()
				surface.SetDrawColor( 100, 100, 100, 255 )
				surface.DrawRect(0,0,frame:GetWide(),frame:GetTall())
			end
		else



			local BlueB = vgui.Create("DButton", frame)
			BlueB:SetText("Join Blue")
			BlueB:SetFont("BFont")
			BlueB:SetPos(4, 4)
			BlueB:SetColor(team.GetColor(2))
			BlueB:SetSize(frame:GetWide()-8,(frame:GetTall()/2)-5)
			BlueB.DoClick = function()
				net.Start("TEAM")
				net.WriteInt(2,3)
				net.SendToServer()
				frame:Close()
			end
			BlueB.Paint = function()
				surface.SetDrawColor( 100, 100, 100, 255 )
				surface.DrawRect(0,0,frame:GetWide(),frame:GetTall())
			end

			local RedB = vgui.Create("DButton", frame)
			RedB:SetText("Join Red")
			RedB:SetFont("BFont")
			RedB:SetPos(4,(frame:GetTall()/2)+1)
			RedB:SetColor(team.GetColor(1))
			RedB:SetSize(frame:GetWide()-8,(frame:GetTall()/2)-5)
			RedB.DoClick = function()
				net.Start("TEAM")
				net.WriteInt(1,3)
				net.SendToServer()
				frame:Close()
			end
			RedB.Paint = function()
				surface.SetDrawColor( 100, 100, 100, 255 )
				surface.DrawRect(0,0,frame:GetWide(),frame:GetTall())
			end
		end
	end
end
