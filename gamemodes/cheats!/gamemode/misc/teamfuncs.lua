teamf = {}

teamf.TeamMsg = function(ply,asd,col)
	net.Start("Cheats:TeamMsg")
	net.WriteString(asd)
	net.WriteColor(col)
	net.Send(ply)
end

teamf.ScrambleDM = function()
	local t1 = {}
	local t2 = {}

	for k,v in pairs(player.GetAll())do
		if(v:Team() == 3)then
			table.insert(t1,v)
		end
	end

	local pamnt = math.ceil(table.Count(t1)/2)
	for i = 1,pamnt do
		local rnum = math.random(1,pamnt)
		table.insert(t2,t1[rnum])
		table.remove(t1,rnum)
	end
	for k,v in next,t1 do
		v:SetTeam(1)
		v:Spawn()
	end
	for k,v in next,t2 do
		v:SetTeam(2)
		v:Spawn()
	end
end

teamf.SetTeam = function(ply,t)
	local t1 = team.NumPlayers(1)
	local t2 = team.NumPlayers(2)
	if(ply:Team() == 1)then
		t1 = t1-1
	elseif(ply:Team() == 2)then
		t2 = t2-1
	end
	if(ply:Team() == t)then
		teamf.TeamMsg(ply,"You cant join your own team!",Color(255,0,0))
	else
		if(t == 1)then
			if(GetGlobalBool("Deathmatch"))then
				teamf.TeamMsg(ply,"You cant join that team right now!",Color(255,0,0))
			else
				if(t1>t2)then
					teamf.TeamMsg(ply,"Too much players in Red team",Color(255,0,0))
				else
					teamf.TeamMsg(ply,"Team set to Red",team.GetColor(t))
					if(ply:Team() != 0 and (!GetGlobalBool("Deathmatch") and !GetGlobalBool("Lobby")))then
						ply:KillSilent()
						CHSpectate(ply)
					else
						ply:Spawn()
					end
					ply:SetTeam(t)
				end
			end
		elseif(t == 2)then
			if(GetGlobalBool("Deathmatch"))then
				teamf.TeamMsg(ply,"You cant join that team right now!",Color(255,0,0))
			else
				if(t2>t1)then
					teamf.TeamMsg(ply,"Too much players in Blue team",Color(255,0,0))
				else
					teamf.TeamMsg(ply,"Team set to Blue",team.GetColor(t))
					if(ply:Team() != 0 and (!GetGlobalBool("Deathmatch") and !GetGlobalBool("Lobby")))then
						ply:KillSilent()
						CHSpectate(ply)
					else
						ply:Spawn()
					end
					ply:SetTeam(t)
				end
			end
		else
			if(t == 3 and !GetGlobalBool("Deathmatch"))then
				teamf.TeamMsg(ply,"You cant join that team right now!",Color(255,0,0))
			else
				teamf.TeamMsg(ply,"Team set to "..team.GetName(t),team.GetColor(t))
				ply:SetTeam(t)
				ply:Spawn()
			end
		end
	end
end

teamf.ScrambleAll = function()--debug function
	local t1 = {}
	local t2 = {}

	for k,v in pairs(player.GetAll())do
		if(v:Team() == 3 or v:Team() == 0)then
			table.insert(t1,v)
		end
	end

	local pamnt = math.ceil(table.Count(t1)/2)
	for i = 1,pamnt do
		local rnum = math.random(1,pamnt)
		table.insert(t2,t1[rnum])
		table.remove(t1,rnum)
	end
	for k,v in pairs(t1)do
		v:SetTeam(1)
		v:Spawn()
	end
	for k,v in pairs(t2)do
		v:SetTeam(2)
		v:Spawn()
	end
end
