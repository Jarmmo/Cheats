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

local function CreateFont()
	surface.CreateFont( "CHAIRD", {
		font = "Roboto Cn",
		extended = true,
		size = 14,
		weight = 600,
		antialias = true
	})
end
CreateFont()

function F_Crosshair()
	local wep = LocalPlayer():GetActiveWeapon()
	local CPos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
	if (wep.Scoped) then CPos = Vector(ScrW()/2,ScrH()/2) end
	if (wep.DrawCustomCrosshair == true and LocalPlayer():Alive())then
		local col = team.GetColor(LocalPlayer():Team())
		if(wep.Scoped == true)then
			surface.DrawCircle(CPos.x,CPos.y,math.Clamp((LocalPlayer():GetActiveWeapon().Primary.Spread+0.05),0,1)*115+2,col.r,col.g,col.b,50-((LocalPlayer():GetActiveWeapon().Primary.Spread*50)/50)*100)
			surface.DrawCircle(CPos.x,CPos.y,(math.Clamp((LocalPlayer():GetActiveWeapon().Primary.Spread+0.05),0,1)*115)+1,0,0,0,50-((LocalPlayer():GetActiveWeapon().Primary.Spread*50)/50)*100)
			draw.SimpleText(math.ceil(LocalPlayer():GetActiveWeapon().Primary.Damage),"CHAIRD",(ScrW()/2)+2,(ScrH()/2)+22,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(math.ceil(LocalPlayer():GetActiveWeapon().Primary.Damage),"CHAIRD",(ScrW()/2),(ScrH()/2)+20,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		surface.SetDrawColor(0,0,0,200)
		draw.Circle(CPos.x,CPos.y,4.5,8)
		surface.SetDrawColor(col.r,col.g,col.b,255)
		draw.Circle(CPos.x,CPos.y,3.5,8)
	end
end
hook.Add("HUDPaint","Crosshairi",F_Crosshair)