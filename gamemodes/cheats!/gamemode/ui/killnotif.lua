hook.Add("CHDeath","CHDeathIndidator",function()
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
		surface.SetDrawColor(r,g,b,255-timeex/2.55)
		local w = 100-timeex*50
		local h = timeex*50
		surface.DrawRect((ScrW()/2)-w/2,((ScrH()/4)*3)-h/2,w,h)
		surface.DrawRect((ScrW()/2)-h/2,((ScrH()/4)*3)-w/2,h,w)
	end)
	timer.Remove("DeathTimer")
	timer.Create("DeathTimer",3,1,function()
		hook.Remove("HUDPaint","CHDeathIndicator")
	end)
end)