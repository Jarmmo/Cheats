local function CreateFont()
	surface.CreateFont( "DNOTIF", {
		font = "Roboto Cn",
		extended = true,
		size = 30,
		weight = 700,
		antialias = true
	})
end
CreateFont()

hook.Add("CHDeath","CHDeathIndidator",function(ply,weapon)
	local col = team.GetColor(LocalPlayer():Team())
	local time = SysTime()
	hook.Add("HUDPaint","CHDeathIndicator",function()
		local timeex = SysTime()-time
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,math.Clamp(ScrH()-timeex*500,ScrH()-102,ScrH()),ScrW(),102)
		surface.DrawRect(0,math.Clamp(-98+timeex*500,-98,0),ScrW(),102)
		surface.SetDrawColor(200,0,0,200)
		surface.DrawRect(0,math.Clamp(ScrH()-timeex*500,ScrH()-100,ScrH()),ScrW(),100)
		surface.DrawRect(0,math.Clamp(-100+timeex*500,-100,0),ScrW(),100)

		if(ply == true or weapon == nil)then
			draw.SimpleText("You killed yourself","DNOTIF",ScrW()/2,math.Clamp(-98+timeex*500,-98,0)+35,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
			draw.SimpleText("You killed yourself","DNOTIF",(ScrW()/2)-2,math.Clamp(-98+timeex*500,-98,0)+33,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		else
			draw.SimpleText(ply.." killed you with their "..weapon,"DNOTIF",ScrW()/2,math.Clamp(-98+timeex*500,-98,0)+35,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
			draw.SimpleText(ply.." killed you with their "..weapon,"DNOTIF",(ScrW()/2)-2,math.Clamp(-98+timeex*500,-98,0)+33,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end

		if(GetGlobalBool("Deathmatch") or GetGlobalBool("Lobby"))then
			surface.SetDrawColor(255,255,255,math.Clamp((timeex*500)-1000,0,255))
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
	end)
	hook.Add("CHDeathr","RemoveI",function()
		hook.Remove("HUDPaint","CHDeathIndicator")
	end)
end)