function CHSpectate(ply)
	local ateam = team.GetPlayers(ply:Team())
	for k,v in pairs(ateam)do
		if(!v:Alive())then
			table.remove(ateam,k)
		end
	end
	if(table.Count(ateam) > 0)then
		net.Start("Cheats:CHDeathr")
		net.Send(ply)
		ply:Spectate(OBS_MODE_IN_EYE)
		ply:SpectateEntity(ateam[1])
		ply.SpecTarget = 1
	end
end

hook.Add("PlayerDeath","CHspecdeath",function(ply)
	if(ply:Team() != 0 and !(GetGlobalBool("Deathmatch") and !GetGlobalBool("Lobby")))then
		timer.Simple(3,function()
			CHSpectate(ply)
		end)
	end
end)

hook.Add("PlayerButtonDown","CHspecchangetarget",function(ply,butt)
	if(ply:Team() != 0 and !ply:Alive() and !(GetGlobalBool("Deathmatch") and !GetGlobalBool("Lobby")))then
		ateam = team.GetPlayers(ply:Team())
		for k,v in pairs(ateam)do
			if(!v:Alive())then
				table.remove(ateam,k)
			end
		end
		if(butt == MOUSE_LEFT)then
			if(ply.SpecTarget == table.Count(ateam))then
				ply.SpecTarget = 1
				ply:SpectateEntity(ateam[ply.SpecTarget])
			else
				ply.SpecTarget = ply.SpecTarget+1
				ply:SpectateEntity(ateam[ply.SpecTarget])
			end
		elseif(butt == MOUSE_RIGHT)then
			if(ply.SpecTarget == 1)then
				ply.SpecTarget = table.Count(ateam)
				ply:SpectateEntity(ateam[ply.SpecTarget])
			else
				ply.SpecTarget = ply.SpecTarget-1
				ply:SpectateEntity(ateam[ply.SpecTarget])
			end
		end

		if(butt == KEY_SPACE and ply:GetObserverMode() == OBS_MODE_IN_EYE)then
			ply:Spectate(OBS_MODE_CHASE)
		elseif(butt == KEY_SPACE and ply:GetObserverMode() == OBS_MODE_CHASE)then
			ply:Spectate(OBS_MODE_IN_EYE)
		end
	end
end)
