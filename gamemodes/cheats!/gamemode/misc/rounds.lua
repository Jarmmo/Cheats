LobbyTimer = 30
RoundDuration = 10
RoundEndTime = 5
RoundCount = 0
RoundLimit = 5

util.AddNetworkString("ROUNDSTART")
util.AddNetworkString("ROUNDLOBBY")

function RoundMsg(msg)
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(msg)
	end
end

function GameStop()
	RoundMsg("Stopping game..")
	SetGlobalBool("Deathmatch",true)
	timer.Remove("LOBBYTIMER")
	timer.Remove("ROUNDTIMER")
	timer.Remove("ROUNDENDTIMER")
	for k,v in pairs(player.GetAll())do
		if(v:Team() != 0)then
			v:SetTeam(3)
			v:Respawn()
		end
	end
end

function GameLobby()
	timer.Create("LOBBYTIMER",LobbyTimer,1,function() RoundStart() GameStart() end)
	RoundMsg("Starting new game in "..LobbyTimer.." seconds!")
	net.Start("ROUNDLOBBY")
	net.Send(player.GetAll())
end

function GameStart()
	SetGlobalBool("Deathmatch",false)
	ScrambleDM()
end

function RoundStart()
	RoundMsg("A round has started!")

	for k,v in pairs(player.GetAll())do
		if(v:Team() == 1 or v:Team() == 2)then
			v:Spawn()
		end
	end

	timer.Create("ROUNDTIMER",RoundDuration,1,RoundEnd)

	net.Start("ROUNDSTART")
	net.Send(player.GetAll())
end

function RoundEnd()
	RoundCount = RoundCount+1
	if(RoundCount >= RoundLimit)then
		GameWin()
	else
		RoundMsg("A round has ended!")
		timer.Create("ROUNDENDTIMER",RoundEndTime,1,RoundStart)
	end
end

function GameWin()
	RoundCount = 0
	RoundMsg("Someone won the game!")
	SetGlobalBool("Deathmatch",true)
	for k,v in pairs(player.GetAll())do
		if(v:Team() != 0)then
			v:SetTeam(3)
			v:Respawn()
		end
	end
end

--add game cancel function, game setup, clientside