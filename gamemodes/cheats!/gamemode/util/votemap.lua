
if CLIENT then
	local play = function(pitch, vol, snd)
		vol = vol or 1
		snd = snd or "buttons/button18.wav"
		EmitSound(snd, LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, vol, 75, 0, pitch)
	end

	local votings = {}

	local function startIt(maps)
		local ass = maps

		surface.CreateFont("ch_votemap_font", {
			font = "Roboto",
			size = ScreenScale(16),
		})

		surface.CreateFont("ch_votemap_tip_font", {
			font = "Roboto",
			size = ScreenScale(8),
		})

		surface.CreateFont("ch_votemap_coming_title", {
			font = "Roboto",
			size = ScreenScale(64),
			weight = 200,
		})

		surface.CreateFont("ch_votemap_coming", {
			font = "Roboto",
			size = ScreenScale(32),
			weight = 800,
		})

		play(100,1,"ui/vote_started.wav")

		local last
		local start = RealTime()
		local time = 30

		local function over()
			play(100,1,"ui/vote_success.wav")
			local namemap = ""
			local score = 0

			for k,v in pairs(votings) do
				if(v > score) then
					score = v
					namemap = k
				end
			end

			local result = ""

			if(score ~= 0) then
				result = namemap
			else
				result = "none"
			end

			hook.Add("HUDPaint", "votemap", function()
				local boxh = ScrH()
				draw.RoundedBox(0,0,0,ScrW(),boxh,Color(0,0,0,225))
				draw.DrawText("Coming up next:","ch_votemap_coming_title",ScrW()*0.5,ScrH()*0.2,Color(255,255,255),TEXT_ALIGN_CENTER)
				draw.DrawText(result,"ch_votemap_coming",ScrW()*0.5,ScrH()*0.2+ScreenScale(64)+16,Color(255,255,255),TEXT_ALIGN_CENTER)
				--ch_votemap_coming
			end)

			timer.Simple(5, function( )
				hook.Remove("HUDPaint", "votemap")
			end)
		end

		for k,v in pairs(ass) do
			votings[v] = 0
		end

		hook.Add("HUDPaint", "votemap", function()
			local maps = 0
			local secollumn = false
			local boxh = ScrH()
			local remaining = time-(RealTime()-start)

			if remaining <= 0 then 
				hook.Remove("HUDPaint", "votemap")
				over()
				return
			end

			draw.RoundedBox(0,0,0,ScrW(),boxh,Color(0,0,0,225))

			local ceiled = math.ceil(remaining)

			if(last ~= ceiled) then
				if last then
					if(remaining < 5 and remaining > 0) then
						play(75,1,"buttons/blip1.wav")
					end
				end
				last = ceiled
			end

			for k,v in pairs(ass) do
				if(maps == 8 or maps > 8) then secollumn = true end
				if secollumn then
					draw.DrawText(votings[v].." | "..string.StripExtension(v).." ["..k.."]","ch_votemap_font",ScrW()*0.8,(ScrH()*0.2)+ScreenScale(16)*(k-8),Color(255,255,255),TEXT_ALIGN_RIGHT)
				else
					draw.DrawText("["..k.."] "..string.StripExtension(v).." | "..votings[v],"ch_votemap_font",ScrW()*0.2,(ScrH()*0.2)+ScreenScale(16)*k,Color(255,255,255),TEXT_ALIGN_LEFT)
				end

				maps = maps + 1
			end
			draw.DrawText("Say the voting in the chat. | "..math.ceil(remaining).." seconds left.","ch_votemap_tip_font",ScrW()*0.2,(ScrH()*0.2)+ScreenScale(16)*9,Color(255,255,255),TEXT_ALIGN_LEFT)
		end)
	end

	net.Receive("votemap", function ( )
		startIt(net.ReadTable())
	end)

	net.Receive("votemap_vote", function()
		local whaat = net.ReadString()
		votings[whaat] = votings[whaat] + 1
		play(100,1,"ui/vote_no.wav")
	end)
elseif SERVER then
	util.AddNetworkString("votemap")
	util.AddNetworkString("votemap_vote")

	local active = false

	local ass = {}
	local votings = {}
	local votedplayers = {}

	function startvote()
		local maps = 0

		for k,v in pairs(file.Find("maps/cs_*.bsp","GAME")) do
			if(maps < 16) then
				table.insert(ass, v)
			end
			maps = maps + 1
		end

		for k,v in pairs(file.Find("maps/de_*.bsp","GAME")) do
			if(maps < 16) then
				table.insert(ass, v)
			end
			maps = maps + 1
		end

		for k,v in pairs(ass) do
			votings[v] = 0
		end

		active = true

		net.Start("votemap")
		net.WriteTable(ass)
		net.Broadcast()

		timer.Simple(30, function()
			active = false
			ass = {}
			votedplayers = {}
			local namemap = ""
			local score = 0

			for k,v in pairs(votings) do
				if(v > score) then
					score = v
					namemap = k
				end
			end

			timer.Simple(5,function()
				if score ~= 0 then
					RunConsoleCommand("changelevel", string.StripExtension( namemap ))
				end
			end)
		end)
	end

	hook.Add("PlayerSay", "votemap", function(ply,txt)

		if active then
			local exists = false

			for k,v in pairs(votedplayers) do
				if(ply == v) then
					exists = true
				end
			end

			if not exists then
				local yes = tonumber(txt)
				if yes then 
					if ass[yes] then
						votings[ass[yes]] = votings[ass[yes]] + 1
						table.insert(votedplayers, ply)
						net.Start("votemap_vote")
						net.WriteString(ass[yes])
						net.Broadcast()
					end
				end
			end
		end
	end)

	concommand.Add("votemap",function()
		startvote()
	end)
end