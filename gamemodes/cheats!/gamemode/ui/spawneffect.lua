if SERVER then
	hook.Add("PlayerSpawn","SpawnEffect",function(ply) ply:SendLua("SpawnEffect()") end)
end

if CLIENT then
	SEAlpha = 0
	SETimeex = 0
	function SpawnEffect()
		SETimeex = SysTime()
		SEAlpha = 255
	end
	hook.Add("PostRenderVGUI","DrawSpawnEffect",function()
		print(SEAlpha-(SysTime()-SETimeex)*100)
		surface.SetDrawColor(200,200,200,math.Clamp(SEAlpha-(SysTime()-SETimeex)*500,0,255))
		surface.DrawRect(0,0,ScrW(),ScrH())
	end)
end