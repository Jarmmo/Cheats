RoundDuration = 10
RoundEndTime = 5
RoundCount = 0
RoundLimit = 5

util.AddNetworkString("ROUNDSTART")

function RoundMsg(msg)
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(msg)
	end
end

function RoundStart()
	RoundMsg("A round has started!")

	timer.Create("ROUNDTIMER",RoundDuration,1,RoundEnd)

	net.Start("ROUNDSTART")
	net.WriteTable({ Count = RoundCount }) -- Table because we might end up sending more stuff
	net.Send(player.GetAll())
end

function RoundEnd()
	RoundCount = RoundCount+1
	if(RoundCount >= RoundLimit)then
		RoundWin()
	else
		RoundMsg("A round has ended!")
		timer.Create("ROUNDENDTIMER",RoundEndTime,1,RoundStart)
	end
end

function RoundWin()
	RoundCount = 0
	RoundMsg("Someone won the game!")
end

--add game cancel function, game setup, clientside