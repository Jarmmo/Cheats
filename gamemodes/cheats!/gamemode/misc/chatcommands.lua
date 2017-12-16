for k,v in pairs(player.GetAll())do
	v:SetNWBool("Voted",false)
end

hook.Add("PlayerSay","chatcommands",function(ply,text)
	if(string.StartWith(text,"!team"))then
		ply:SendLua("TeamMenu()")
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