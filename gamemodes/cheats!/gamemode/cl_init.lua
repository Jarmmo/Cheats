include("shared.lua")
include("misc/crosshair.lua")
include("misc/quickswitch.lua")
include("misc/votemap.lua")
include("ui/hud.lua")
include("ui/teammenu.lua")

hook.Add("HUDPaint","SpawnSelectTeam",function()
	TeamMenu()
	hook.Remove("HUDPaint","SpawnSelectTeam")
end)

hook.Add("CreateClientsideRagdoll","begoneTHOT",function(entit,rag) rag:SetSaveValue( "m_bFadingOut", true ) end)