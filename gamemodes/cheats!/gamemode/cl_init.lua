include("shared.lua")
include("misc/crosshair.lua")
include("misc/quickswitch.lua")
include("misc/votemap.lua")
include("ui/hud.lua")

hook.Add("CreateClientsideRagdoll","begoneTHOT",function(entit,rag) rag:SetSaveValue( "m_bFadingOut", true ) end)

function GM:CreateTeams()
	return "fuck off"
end