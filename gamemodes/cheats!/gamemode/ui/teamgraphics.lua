local function CreateFont()
	surface.CreateFont( "RMF", {
		font = "Roboto Cn",
		extended = true,
		size = 40,
		weight = 700,
		antialias = true
	})
end
CreateFont()

hook.Add("TeamMsg","TeamMsg",function(msg,col)
	local time = SysTime()
	hook.Add("HUDPaint","TeamMsg",function()
		local timeex = SysTime()-time
		local pos = math.Clamp(math.sin((timeex*math.pi)/5)*3000,0,400)
		surface.SetDrawColor(Color(col.r-100,col.g-100,col.b-100,100))
		surface.DrawRect((ScrW()-pos)-2,((ScrH()/2)-37)+70,404,74)
		surface.SetDrawColor(Color(col.r,col.g,col.b,100))
		surface.DrawRect(ScrW()-pos,((ScrH()/2)-35)+70,400,70)
		draw.SimpleText(msg,"RMF",((ScrW()-pos)+2)+200,((ScrH()/2)+2)+70,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(msg,"RMF",(ScrW()-pos)+200,((ScrH()/2))+70,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end)
	timer.Simple(5,function() hook.Remove("HUDPaint","TeamMsg") end)
end)