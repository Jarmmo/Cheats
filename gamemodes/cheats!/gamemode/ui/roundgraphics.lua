local function CreateFont()
	surface.CreateFont( "NFont1", {
		font = "Roboto Cn",
		extended = true,
		size = ScrW()/60,
		weight = 500,
		antialias = true
	})
	surface.CreateFont( "NFont2", {
		font = "Roboto Lt",
		extended = true,
		size = ScrW()/100,
		weight = 500,
		antialias = true
	})
	surface.CreateFont( "RMF", {
		font = "Roboto Cn",
		extended = true,
		size = 40,
		weight = 700,
		antialias = true
	})
end
CreateFont()

local time = 0
local txt = ""
local mtxt = "BO5"
local startt = 0
local last = 0
local no = true
local stop = true

hook.Add("GameLobby","lobby",function(asd)
	time = SysTime()
	startt = asd
	no = false
	stop = false
end)

hook.Add("RoundMsg","RoundMsg",function(msg)
	local time = SysTime()
	hook.Add("HUDPaint","RoundMsg",function()
		local timeex = SysTime()-time
		local col = team.GetColor(LocalPlayer():Team())
		local pos = math.Clamp(math.sin((timeex*math.pi)/5)*1000,0,400)
		surface.SetDrawColor(Color(col.r-100,col.g-100,col.b-100,100))
		surface.DrawRect((ScrW()-pos)-2,(ScrH()/2)-37,404,74)
		surface.SetDrawColor(Color(col.r,col.g,col.b,100))
		surface.DrawRect(ScrW()-pos,(ScrH()/2)-35,400,70)
		draw.SimpleText(msg,"RMF",((ScrW()-pos)+2)+200,(ScrH()/2)+2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(msg,"RMF",(ScrW()-pos)+200,(ScrH()/2),Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end)
	timer.Simple(5,function() hook.Remove("HUDPaint","RoundMsg") end)
end)

hook.Add("Think","LobbyTimeCountdown",function()
	if not stop then
		if CurTime() - last > 1 then
			startt = startt-1
			last = CurTime()
		end
		txt = "Starting game in ".. startt .." seconds! Pick your team!"
	end
end)

hook.Add("GameStop","stop",function()
	hook.Remove("HUDPaint","CHRoundWinNotif")
	hook.Remove("HUDPaint","CHRoundLossNotif")
	no = true
end)

hook.Add("GameWin","stop",function()
	hook.Remove("HUDPaint","CHRoundWinNotif")
	hook.Remove("HUDPaint","CHRoundLossNotif")
	no = true
end)

hook.Add("RoundStart","start",function(red,blue)
	txt = "Red  "..red.." - "..blue.."  Blue"
	stop = true
	hook.Remove("HUDPaint","CHRoundWinNotif")
	hook.Remove("HUDPaint","CHRoundLossNotif")
end)

hook.Add("HUDPaint","CH_roundscreenelements",function()-- what the fuck am i supposed to name this shit
	if not no then
		local notifcol = team.GetColor(LocalPlayer():Team())
		local pos = math.Clamp(((SysTime()-time)*100)-72,-999,0)
		local notifp = {
			{x = (ScrW()/2)-(ScrW()/6),y = pos+20},
			{x = (ScrW()/2)+(ScrW()/6),y = pos+20},
			{x = (ScrW()/2)+(ScrW()/8),y = pos+70},
			{x = (ScrW()/2)-(ScrW()/8),y = pos+70},
		}
		local notifp2 = {
			{x = 0,y = pos+0},
			{x = ScrW(),y = pos+0},
			{x = ScrW(),y = pos+20},
			{x = 0,y = pos+20},
		}

		local notifp22 = {
			{x = (ScrW()/2)-(ScrW()/6)-2,y = pos+22},
			{x = (ScrW()/2)+(ScrW()/6)+2,y = pos+22},
			{x = (ScrW()/2)+(ScrW()/8)+2,y = pos+72},
			{x = (ScrW()/2)-(ScrW()/8)-2,y = pos+72},
		}
		local notifp222 = {
			{x = 0,y = pos+0},
			{x = ScrW(),y = pos+0},
			{x = ScrW(),y = pos+22},
			{x = 0,y = pos+22},
		}

		surface.SetDrawColor(Color(notifcol.r-100,notifcol.g-100,notifcol.b-100,100))
		draw.NoTexture()
		surface.DrawPoly(notifp22)-- FUCK POLYGONS
		surface.DrawPoly(notifp222)

		surface.SetDrawColor(Color(notifcol.r,notifcol.g,notifcol.b,100))
		surface.DrawPoly(notifp)
		surface.DrawPoly(notifp2)

		wide,tall = surface.GetTextSize("AAA")


		if not stop then
			draw.SimpleText(txt,"NFont1",(ScrW()/2)+2,pos+37,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(txt,"NFont1",(ScrW()/2),pos+35,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(txt,"NFont1",(ScrW()/2)+2,pos+27,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(txt,"NFont1",(ScrW()/2),pos+25,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

			draw.SimpleText(mtxt,"NFont2",(ScrW()/2)+1,pos+26+tall/2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(mtxt,"NFont2",(ScrW()/2),pos+25+tall/2,Color(200,200,200,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
end)

hook.Add("RoundWin","rwin",function()
	local timeex = SysTime()
	hook.Add("HUDPaint","CHRoundWinNotif",function()
		surface.SetDrawColor(Color(255,255,0,math.Clamp((SysTime()-timeex)*1000,0,50)))
		surface.DrawRect(0,ScrH()/5-math.Clamp((SysTime()-timeex)*100,0,10),ScrW(),math.Clamp(((SysTime()-timeex)*200)+100,100,120))
		surface.SetDrawColor(Color(100,100,100,math.Clamp((SysTime()-timeex)*500,0,250)))
		surface.DrawRect(0,ScrH()/5,ScrW(),100)

		draw.SimpleText("Victory!","NFont1",(ScrW()/2)+2,(ScrH()/5)+52,Color(0,0,0,(SysTime()-timeex)*1000),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("Victory!","NFont1",(ScrW()/2),(ScrH()/5)+50,Color(255,255,0,(SysTime()-timeex)*1000),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end)
end)

hook.Add("RoundLoss","rloss",function()
	local timeex = SysTime()
	hook.Add("HUDPaint","CHRoundLossNotif",function()
		surface.SetDrawColor(Color(255,0,0,math.Clamp((SysTime()-timeex)*1000,0,50)))
		surface.DrawRect(0,ScrH()/5-math.Clamp((SysTime()-timeex)*100,0,10),ScrW(),math.Clamp(((SysTime()-timeex)*200)+100,100,120))
		surface.SetDrawColor(Color(100,100,100,math.Clamp((SysTime()-timeex)*500,0,250)))
		surface.DrawRect(0,ScrH()/5,ScrW(),100)

		draw.SimpleText("Defeat!","NFont1",(ScrW()/2)+2,(ScrH()/5)+52,Color(0,0,0,(SysTime()-timeex)*1000),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("Defeat!","NFont1",(ScrW()/2),(ScrH()/5)+50,Color(255,0,0,(SysTime()-timeex)*1000),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end)
end)