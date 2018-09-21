for k,v in pairs(player.GetAll())do
	v:SetNWBool("Voted",false)
end

hook.Add("PlayerSay","chatcommands",function(ply,text)
	if(string.StartWith(string.lower(text),"!team"))then
		net.Start("Cheats:TeamMenu")
		net.Send(ply)
		return ""
	end

	if(string.StartWith(string.lower(text),"!stop"))then
		GameStop()
		return ""
	end

	if(string.StartWith(string.lower(text),"!start"))then
		if(GetGlobalBool("Deathmatch") and !ply:GetNWBool("Voted") and ply:Team() != 0)then
			ply:SetNWBool("Voted",true)
			SetGlobalInt("Voteamount",GetGlobalInt("Voteamount")+1)
			if((100*GetGlobalInt("Voteamount")/table.Count(player.GetAll())) > 75)then
				for k,v in pairs(player.GetAll())do
					v:SetNWBool("Voted",false)
					v:ChatPrint(ply:Name().." has voted to start a game! They are the last one to vote!")
				end
				GameLobby()
				SetGlobalInt("Voteamount",0)
			else
				for k, v in pairs(player.GetAll()) do
					v:ChatPrint(ply:Name().." has voted to start a game! ("..GetGlobalInt("Voteamount").."/"..math.ceil(0.75*table.Count(player.GetAll()))..")")
					v:ChatPrint("Type !start to vote!")
				end
			end
			return ""
		elseif(ply:GetNWBool("Voted"))then
			SetGlobalInt("Voteamount",GetGlobalInt("Voteamount")-1)
			ply:SetNWBool("Voted", false)
			for k, v in pairs(player.GetAll()) do
				
				v:ChatPrint(ply:Name() .. "has unvoted to start a game! ("..GetGlobalInt("Voteamount").."/"..math.ceil(0.75*table.Count(player.GetAll()))..")")
				v:ChatPrint("Type !start to vote!")
			end
			return ""
		end
	end
end)
