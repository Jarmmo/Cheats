function draw.Circle( x, y, radius, seg )
	local cir = {}
	
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	
	surface.DrawPoly( cir )
end

function F_Crosshair()
	local wep = LocalPlayer():GetActiveWeapon()
	local CPos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
	if (wep.Scoped) then CPos = Vector(ScrW()/2,ScrH()/2) end
	if (wep.DrawCustomCrosshair == true and LocalPlayer():Alive())then
		local col = team.GetColor(LocalPlayer():Team())
		if(wep.Scoped == true)then
			local vel = LocalPlayer():GetVelocity():Length()/7
			surface.SetDrawColor(col.r,col.g,col.b,50)
			surface.DrawCircle(CPos.x,CPos.y,math.Clamp((vel)-5,0,9999),20,20,20,200-(vel/50)*255)
			surface.DrawCircle(CPos.x,CPos.y,math.Clamp((vel)-5,0,9999)-0.5,20,20,20,200-(vel/50)*255)
		end
		surface.SetDrawColor(0,0,0,200)
		draw.Circle(CPos.x,CPos.y,4.2,8)
		surface.SetDrawColor(col.r,col.g,col.b,255)
		draw.Circle(CPos.x,CPos.y,3.5,8)
	end
end
hook.Add("HUDPaint","Crosshairi",F_Crosshair)