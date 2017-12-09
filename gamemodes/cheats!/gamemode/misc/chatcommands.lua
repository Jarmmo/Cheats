for k,v in pairs(player.GetAll())do
	v:SetNWBool("Voted",false)
end

hook.Add("PlayerSay","chatcommands",function(ply,text)
	if(string.StartWith(text,"!team"))then
		local teams = team.GetAllTeams()
		tc1 = table.Count(team.GetPlayers(1))
		tc2 = table.Count(team.GetPlayers(2))
		if(ply:Team() == 1)then
			tc1 = tc1-1
		elseif(ply:Team() == 2)then
			tc2 = tc2-1
		end
		if(GetGlobalBool("Deathmatch"))then
			if(ply:Team() == 3)then return "" end
			ply:SetTeam(3)
			ply:Spawn()
			ply:ChatPrint("Set team to Deathmatch")
		else
			if(tc1>tc2 and ply:Team() != 2)then
				ply:SetTeam(2)
				ply:KillSilent()
				ply:ChatPrint("Set team to Blue")
			elseif(tc1<tc2 and ply:Team() != 1)then
				ply:SetTeam(1)
				ply:Spawn()
				ply:ChatPrint("Set team to Red")
			elseif(tc1==tc2)then
				local teamr = math.random(1, 2)
				ply:SetTeam(teamr)
				ply:ChatPrint("Set team to ".. team.GetName(teamr))
				ply:Spawn()
			end
		end
		return ""
	end

	if(string.StartWith(text,"!start"))then
		if(GetGlobalBool("Deathmatch") and !ply:GetNWBool("Voted") and ply:Team() != 0)then
			ply:SetNWBool("Voted",true)
			SetGlobalInt("Voteamount",GetGlobalInt("Voteamount")+1)
			if((100*GetGlobalInt("Voteamount")/table.Count(player.GetAll())) > 75)then
				GameLobby()
				SetGlobalInt("Voteamount",0)
				for k,v in pairs(player.GetAll())do
					v:SetNWBool("Voted",false)
				end
			end
			return ""
		elseif(ply:GetNWBool("Voted"))then
			ply:ChatPrint("Already voted!")
			return ""
		end
	end
end)