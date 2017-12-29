SEAlpha = 0
SETimeex = 0

hook.Add("CHDeathr","SpawnEffect",function()
	SETimeex = SysTime()
	SEAlpha = 255
	if(GetGlobalBool("Deathmatch") or GetGlobalBool("Lobby"))then
		hook.Add("PostRenderVGUI","DrawSpawnEffect",spawneffectf)
	end
end)

	function spawneffectf()
		if(SEAlpha < 0)then
			hook.Remove("PostRenderVGUI","DrawSpawnEffect")
		end
		surface.SetDrawColor(200,200,200,math.Clamp(SEAlpha-(SysTime()-SETimeex)*500,0,255))
		surface.DrawRect(0,0,ScrW(),ScrH())
	end