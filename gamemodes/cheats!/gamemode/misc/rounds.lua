local function defaults()
	LobbyTimer = 10
	RoundDuration = 300
	RoundEndTime = 5
	RoundCount = 0
	RoundLimit = 5
	RoundScore = {red = 0, blue = 0}
end
defaults()

function RoundMsg(asd)
	for k, v in pairs(player.GetAll()) do
		v:SendLua("hook.Call('RoundMsg', GM, '"..asd.."' )")
	end
end

function GameStop()
	RoundMsg("Stopping game..")
	hook.Remove("Think","CHRoundThink")
	SetGlobalBool("Lobby",false)
	SetGlobalBool("Deathmatch",true)
	timer.Remove("LOBBYTIMER")
	timer.Remove("ROUNDTIMER")
	timer.Remove("ROUNDENDTIMER")
	defaults()
	for k,v in pairs(player.GetAll())do
		if(v:Team() != 0)then
			v:UnSpectate()
			v:SendLua("hook.Call('GameStop')")
			v:SetTeam(3)
			v:Spawn()
		end
	end
end

function RoundStart()
	teamf.ScrambleDM()
	SetGlobalBool("Lobby",false)

	RoundMsg("A round has started!")

	for k,v in pairs(player.GetAll())do
		if(v:Team() == 1 or v:Team() == 2)then
			v:UnSpectate()
			v:Spawn()
			v:SendLua("hook.Run('RoundStart',"..RoundScore.red..","..RoundScore.blue..")")
		end
	end

	hook.Add("Think","CHRoundThink",function()
		local red = team.GetPlayers(1)
		local blue = team.GetPlayers(2)
		local both = table.Add(red,blue)
		local ra = false
		local ba = false

		for k,v in pairs(both)do
			if(v:Team() == 1 and v:Alive())then
				ra = true
			end
			if(v:Team() == 2 and v:Alive())then
				ba = true
			end 
		end

		if(!ba)then
			timer.Remove("ROUNDTIMER")
			RoundMsg("Red wins!")
			RoundScore.red = RoundScore.red+1
			RoundEnd(1)
		elseif(!ra)then
			timer.Remove("ROUNDTIMER")
			RoundMsg("Blue wins!")
			RoundScore.blue = RoundScore.blue+1
			RoundEnd(2)
		end
	end)

	timer.Create("ROUNDTIMER",RoundDuration,1,function()
		RoundEnd(0)
	end)
end

function GameLobby()
	SetGlobalBool("Lobby",true)
	SetGlobalBool("Deathmatch",false)
	timer.Create("LOBBYTIMER",LobbyTimer,1,RoundStart)
	for k,v in pairs(player.GetAll())do
		if(v:Team() != 0)then
			v:SendLua("hook.Run('GameLobby',"..LobbyTimer..")")
		end
	end
end

function RoundEnd(winner)
	local loser
	if(winner == 1)then
		loser = 2
	elseif(winner == 2)then
		loser = 1
	end
	if(winner != 0)then
		for k,v in pairs(team.GetPlayers(winner))do-- |   |  ||
			v:SendLua("hook.Call('RoundWin')")------- ____|____
		end------------------------------------------     |
		for k,v in pairs(team.GetPlayers(loser))do--- ||  |  |_
			v:SendLua("hook.Call('RoundLoss')")------  hehexd
		end
	end
	hook.Remove("Think","CHRoundThink")
	RoundCount = RoundCount+1
	if(RoundCount >= RoundLimit)then
		GameWin()	
	else
		timer.Create("ROUNDENDTIMER",RoundEndTime,1,RoundStart)
		for k,v in pairs(player.GetAll())do
			if(v:Team() != 0)then
				v:SendLua("hook.Call('RoundEnd')")
			end
		end
	end
end

function GameWin()
	hook.Remove("Think","CHRoundThink")
	defaults()
	RoundCount = 0
	SetGlobalBool("Deathmatch",true)
	timer.Create("ROUNDENDTIMER",RoundEndTime,1,function()
		for k,v in pairs(player.GetAll())do
			if(v:Team() != 0)then
				v:UnSpectate()
				v:SetTeam(3)
				v:Spawn()
			end
		end
	end)
	for k,v in pairs(player.GetAll())do
		if(v:Team() != 0)then
			v:SendLua("hook.Call('GameWin')")
		end
	end
end