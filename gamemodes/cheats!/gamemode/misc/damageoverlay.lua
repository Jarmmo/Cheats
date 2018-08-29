if SERVER then
	function GM:EntityTakeDamage(ply,dmg)
		local attacker = dmg:GetAttacker()
		
		if not ply:IsPlayer() or not attacker:IsPlayer() then return end
		
		net.Start("Cheats:DamageOverlay") 
		net.WriteFloat(dmg:GetDamage())
		net.Send(attacker)
	end
	
	return
end

-- Client side ok

local damagetable = 
{
	StartAt = 0,
	Damage = 0,
}

local function magicnumber(num)
	return math.Rand(-math.Clamp(math.Clamp(num,0,100)/20,0,5),math.Clamp(math.Clamp(num,0,100)/20,0,5))
end

hook.Add("HUDPaint", "DamageOverlay", function()
	local timeex = SysTime() - damagetable.StartAt

	if(timeex > 1)then
		damagetable.Damage = 0
	end

	draw.Text({text = tostring(math.floor(damagetable.Damage)),
		font = "Font2",
		pos = {ScrW()/2+magicnumber(damagetable.Damage),ScrH()/2-25+magicnumber(damagetable.Damage)},
		xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER,
		color = Color(100,0,0,255-timeex*255)})
	draw.Text({text = tostring(math.floor(damagetable.Damage)),
		font = "Font2",
		pos = {ScrW()/2+magicnumber(damagetable.Damage)/2,ScrH()/2-25+magicnumber(damagetable.Damage)/2},
		xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER,
		color = Color(255,0,0,255-timeex*255)})
	draw.Text({text = tostring(math.floor(damagetable.Damage)),
		font = "Font2",
		pos = {ScrW()/2,ScrH()/2-25},
		xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER,
		color = Color(255,100,100,255-timeex*255)})

end)

net.Receive("Cheats:DamageOverlay",function()
	damagetable.StartAt = SysTime()
	damagetable.Damage = damagetable.Damage + net.ReadFloat()
end)