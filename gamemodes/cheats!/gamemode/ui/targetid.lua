local function CreateFont()
	surface.CreateFont( "TID", {
		font = "Roboto Cn",
		extended = true,
		size = 20,
		weight = 700,
		antialias = true
	})
end
CreateFont()

hook.Add("HUDPaint","CHTargetid",function()
	local col = team.GetColor(LocalPlayer():Team())
	local ent = LocalPlayer():GetEyeTrace().Entity
	if(IsValid(ent) and ent:IsPlayer() and (IsValid(LocalPlayer():GetActiveWeapon()) and !LocalPlayer():GetActiveWeapon().Scoped))then
		draw.SimpleText(ent:Name(),"TID",(ScrW()/2)+2,(ScrH()/2)+22,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(ent:Name(),"TID",ScrW()/2,(ScrH()/2)+20,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end)