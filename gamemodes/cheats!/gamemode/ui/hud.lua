local function CreateFont()
	surface.CreateFont( "Font1", {
		font = "Roboto Cn",
		extended = true,
		size = 50,
		weight = 500,
		antialias = true
	})

	surface.CreateFont( "Font2", {
		font = "Roboto Cn",
		extended = true,
		size = 15,
		weight = 800,
		antialias = true
	})
end
CreateFont()

hook.Add("HUDPaint","CHEATHUD",function()
	--ammo
	local col = team.GetColor(LocalPlayer():Team())
	local wep = LocalPlayer():GetActiveWeapon()

	local w = 130
	local h = 70

	local points = {
		{ x = ScrW()+1, y = ScrH()+1 },
		{ x = ScrW()-w, y = ScrH()+1 },
		{ x = ScrW()-w, y = ScrH()-(h-20) },
		{ x = ScrW()-(w-20), y = ScrH()-(h) },
		{ x = ScrW(), y = ScrH()-h }
	}
	local points2 = {
		{ x = ScrW()+1, y = ScrH()+1 },
		{ x = ScrW()-(w+2), y = ScrH()+1 },
		{ x = ScrW()-(w+2), y = ScrH()-(h-19) },
		{ x = ScrW()-(w-18), y = ScrH()-(h+2) },
		{ x = ScrW(), y = ScrH()-(h+2)}
	}

	if(IsValid(wep) and wep.Primary.Ammo != "none" and LocalPlayer():Alive())then
		draw.NoTexture()
		surface.SetDrawColor(Color(col.r-100,col.g-100,col.b-100,100))
		surface.DrawPoly(points2)
		surface.SetDrawColor(Color(col.r,col.g,col.b,100))
		surface.DrawPoly(points)

		surface.SetFont("Font1")
		surface.SetTextColor(0,0,0,255)
		surface.SetTextPos((ScrW()-58)-surface.GetTextSize(wep:Clip1())/2,ScrH()-55)
		surface.DrawText(wep:Clip1())
		surface.SetTextColor(255,255,255,255)
		surface.SetTextPos((ScrW()-60)-surface.GetTextSize(wep:Clip1())/2,ScrH()-57)
		surface.DrawText(wep:Clip1())
	end

	local hp = {
		{ x = 0, y = ScrH() },
		{ x = 0, y = ScrH()-(h) },
		{ x = w-20, y = ScrH()-h },
		{ x = w, y = ScrH()-(h-20) },
		{ x = w, y = ScrH() },
	}
	local hp2 = {
		{ x = 0, y = ScrH() },
		{ x = 0, y = ScrH()-(h+2) },
		{ x = w-19, y = ScrH()-(h+2) },
		{ x = w+2, y = ScrH()-(h-19) },
		{ x = w+2, y = ScrH() },
	}

	if(LocalPlayer():Alive() and LocalPlayer():Team() != 0)then
		draw.NoTexture()
		surface.SetDrawColor(Color(col.r-100,col.g-100,col.b-100,100))
		surface.DrawPoly(hp2)
		surface.SetDrawColor(Color(col.r,col.g,col.b,100))
		surface.DrawPoly(hp)

		surface.SetFont("Font1")

		surface.SetTextColor(0,0,0,255)
		surface.SetTextPos(60-surface.GetTextSize(math.Clamp(LocalPlayer():Health(),0,100))/2,ScrH()-55)
		surface.DrawText(math.Clamp(LocalPlayer():Health(),0,100))

		surface.SetTextColor(255,255,255,255)
		surface.SetTextPos(62-surface.GetTextSize(math.Clamp(LocalPlayer():Health(),0,100))/2,ScrH()-57)
		surface.DrawText(math.Clamp(LocalPlayer():Health(),0,100))
	end
end)

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudGeiger = true,
	CHudCrosshair = true,
	CHudSecondaryAmmo = true,
	CHudZoom = true,
	CHudWeaponSelection = true
}

hook.Add("HUDShouldDraw","HideHUD",function(name)
	if(hide[ name ])then return false end
end)

function GM:HUDDrawTargetID() end