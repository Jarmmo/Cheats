local function CreateFont()
	surface.CreateFont( "KNOTIF", {
		font = "Roboto Cn",
		extended = true,
		size = 30,
		weight = 700,
		antialias = true
	})
end
CreateFont()

hook.Add("CHKill","CHDeathIndidator",function(ply)
	local col = team.GetColor(LocalPlayer():Team())
	local r = col.r
	local g = col.g
	local b = col.b
	local time = SysTime()
	hook.Add("HUDPaint","CHDeathIndicator",function()
		local timeex = SysTime()-time
		r = r+1
		g = g+1
		b = b+1
		surface.SetDrawColor(r,g,b,255-timeex*300)
		local w1 = math.Clamp(400-timeex*600,200,500)
		local h1 = 20+timeex*50
		surface.DrawRect((ScrW()/2)-w1/2,((ScrH()/4)*3)-h1/2,w1,h1)
		surface.SetDrawColor(r-100,g-100,b-100,255-timeex*300)
		surface.DrawRect((ScrW()/2)-(w1/2)-2,((ScrH()/4)*3)-(h1/2)-2,w1+4,h1+4)

		draw.SimpleText("Killed "..ply,"KNOTIF",(ScrW()/2)+math.Rand(-6,6),((ScrH()/4)*3)+math.Rand(-6,6),Color(timeex*510,0,0,255-timeex*250),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("Killed "..ply,"KNOTIF",(ScrW()/2),((ScrH()/4)*3),Color(255,timeex*510,timeex*510,255-timeex*300),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end)
	timer.Remove("DeathTimer")
	timer.Create("DeathTimer",3,1,function()
		hook.Remove("HUDPaint","CHDeathIndicator")
	end)
end)