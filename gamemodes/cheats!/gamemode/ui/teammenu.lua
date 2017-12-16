if SERVER then
	util.AddNetworkString("TEAM")
	net.Receive("TEAM",function(_,ply)
		local t = net.ReadInt(3)
		teamf.SetTeam(ply,t)
	end)
end


if CLIENT then
	function TeamMenu()
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

		if(GetGlobalBool("Deathmatch"))then
			local DermaButton = vgui.Create("DButton", frame)
			DermaButton:SetText("Join deathmatch")
			DermaButton:SetFont("BFont")
			DermaButton:SetPos(4, 4)
			DermaButton:SetColor(team.GetColor(3))
			DermaButton:SetSize(frame:GetWide()-8,frame:GetTall()-8)
			DermaButton.DoClick = function()
				net.Start("TEAM")
				net.WriteInt(3,3)
				net.SendToServer()
				frame:Close()
			end
		else
			local BlueB = vgui.Create("DButton", frame)
			BlueB:SetText("Join Blue")
			BlueB:SetFont("BFont")
			BlueB:SetPos(4, 4)
			BlueB:SetColor(team.GetColor(2))
			BlueB:SetSize(frame:GetWide()-8,(frame:GetTall()/2)-4)
			BlueB.DoClick = function()
				net.Start("TEAM")
				net.WriteInt(2,3)
				net.SendToServer()
				frame:Close()
			end
			local RedB = vgui.Create("DButton", frame)
			RedB:SetText("Join Red")
			RedB:SetFont("BFont")
			RedB:SetPos(4,frame:GetTall()/2)
			RedB:SetColor(team.GetColor(1))
			RedB:SetSize(frame:GetWide()-8,(frame:GetTall()/2)-4)
			RedB.DoClick = function()
				net.Start("TEAM")
				net.WriteInt(1,3)
				net.SendToServer()
				frame:Close()
			end
		end
	end
end
