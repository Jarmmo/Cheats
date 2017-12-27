include("shared.lua")
include("misc/crosshair.lua")
include("misc/quickswitch.lua")
include("misc/votemap.lua")
include("ui/hud.lua")
include("ui/teammenu.lua")
include("ui/roundgraphics.lua")
include("ui/teamgraphics.lua")
include("misc/sh_playerdeath.lua")
include("ui/spawneffect.lua")
include("ui/targetid.lua")
include("ui/killnotif.lua")

hook.Remove("CreateMove","AIMBOT")

RoundStarted = false

hook.Add("HUDPaint","SpawnSelectTeam",function()
	if(LocalPlayer():Team() == 0)then
		TeamMenu()
	end
	hook.Remove("HUDPaint","SpawnSelectTeam")
end)

hook.Add("RoundStart","variable",function(red,blue)
	RoundStarted = true
end)

hook.Add("GameStop","variable",function()
	RoundStarted = false
end)

hook.Add("GameWin","variable",function()
	RoundStarted = false
end)

hook.Add("CreateClientsideRagdoll","begoneTHOT",function(entit,rag) rag:SetSaveValue( "m_bFadingOut", true ) end)
