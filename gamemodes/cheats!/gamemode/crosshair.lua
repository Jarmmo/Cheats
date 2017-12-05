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
	if (wep.DrawCustomCrosshair == true)then
		local CPos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
		surface.SetDrawColor( 255,100,100, 255)
		draw.Circle(CPos.x,CPos.y,3.5,8)
	end
end
hook.Add("HUDPaint","Crosshairi",F_Crosshair)