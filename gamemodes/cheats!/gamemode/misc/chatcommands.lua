for k,v in pairs(player.GetAll())do
	v:SetNWBool("Voted",false)
end

hook.Add("PlayerSay","chatcommands",function(ply,text)
	if(string.StartWith(string.lower(text),"!team"))then
		ply:SendLua("TeamMenu()")
		return ""
	end

	if(string.StartWith(string.lower(text),"!start"))then
		if(GetGlobalBool("Deathmatch") and !ply:GetNWBool("Voted") and ply:Team() != 0)then
			ply:SetNWBool("Voted",true)
			SetGlobalInt("Voteamount",GetGlobalInt("Voteamount")+1)
			if((100*GetGlobalInt("Voteamount")/table.Count(player.GetAll())) > 75)then
				for k,v in pairs(player.GetAll())do
					v:SetNWBool("Voted",false)
					v:ChatPrint(ply:Name().." has voted to start a game! He is the last one to vote!")
				end
				GameLobby()
				SetGlobalInt("Voteamount",0)
			else
				for k, v in pairs(player.GetAll()) do
					v:ChatPrint(ply:Name().." as voted to start a game! ("..GetGlobalInt("Voteamount").."/"..0.75*table.Count(player.GetAll())..")")
					v:ChatPrint("Type !start to vote!")
				end
			end
			return ""
		elseif(ply:GetNWBool("Voted"))then
			ply:ChatPrint("Already voted!")
			return ""
		end
	end
end)