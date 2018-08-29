if SERVER then
	function GM:EntityTakeDamage(ply,dmg)
		local attacker = dmg:GetAttacker()
		
		if not ply:IsPlayer() and not attacker:IsPlayer() then return end
		
		net.Start("Cheats:DamageOverlay") 
		net.WriteFloat(dmg:GetDamage())
		net.WriteEntity(ply)
		net.Send(attacker)
	end
	
	return
end

-- Client side ok

local damagetable = {}

hook.Add("HUDPaint", "DamageOverlay", function()
	for k,v in next,damagetable do
		local egg = math.Clamp(CurTime() - v.StartAt,0,1)
		
		local alpha = 255 - 255 * egg
		local pos = v.Pos:ToScreen()
		
		surface.SetFont("Font1")
		surface.SetTextColor(255,255,255,alpha)
		surface.SetTextPos(pos.x,pos.y)
		surface.DrawText("-"..tostring(v.Damage))
	end
end)

net.Receive("Cheats:DamageOverlay",function()
	local float = net.ReadFloat()
	local ent = net.ReadEntity()
	local steamid = ent:SteamID64()
	
	local pos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
	
	if damagetable[steamid] then
		if CurTime()-damagetable[steamid].StartAt < 1 then
			float = float + damagetable[steamid].Damage
		end
	end
	
	damagetable[steamid] = {
		StartAt = CurTime(),
		Damage = float,
		Pos = damagetable[steamid] and damagetable[steamid].Pos or pos
	}
end)