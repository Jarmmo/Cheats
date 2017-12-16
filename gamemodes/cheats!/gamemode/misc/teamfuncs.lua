teamf = {}


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
	for k,v in pairs(t1)do
		v:SetTeam(1)
		v:Spawn()
	end
	for k,v in pairs(t2)do
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
		ply:ChatPrint("You cant join your own team!")
	else
		if(t == 1)then
			if(GetGlobalBool("Deathmatch"))then
				ply:ChatPrint("You cant join that team right now!")
			else
				if(t1>t2)then
					ply:ChatPrint("Too much players in Red team")
				else
					ply:ChatPrint("Team set to Red")
					ply:SetTeam(t)
					ply:Spawn()
				end
			end
		elseif(t == 2)then
			if(GetGlobalBool("Deathmatch"))then
				ply:ChatPrint("You cant join that team right now!")
			else
				if(t2>t1)then
					ply:ChatPrint("Too much players in Blue team")
				else
					ply:ChatPrint("Team set to Blue")
					ply:SetTeam(t)
					ply:Spawn()
				end
			end
		else
			if(t == 3 and !GetGlobalBool("Deathmatch"))then
				ply:ChatPrint("You cant join that team right now!")
			else
				ply:ChatPrint("Team set to "..team.GetName(t))
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