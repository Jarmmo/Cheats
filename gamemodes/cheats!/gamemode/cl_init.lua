include("shared.lua")
include("misc/crosshair.lua")
include("misc/quickswitch.lua")
include("misc/votemap.lua")
include("misc/anticheat_cl.lua")
include("ui/hud.lua")
include("ui/teammenu.lua")
include("ui/roundgraphics.lua")
include("ui/teamgraphics.lua")
include("misc/sh_playerdeath.lua")
include("ui/spawneffect.lua")
include("ui/targetid.lua")
include("ui/killnotif.lua")
include("ui/deathnotif.lua")
include("misc/particles.lua")

RoundStarted = false

--[[
util.AddNetworkString("Cheats:GameLobby")
]]

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	return false
end

hook.Add("HUDPaint","SpawnSelectTeam",function()
	if(LocalPlayer():Team() == 0)then
		TeamMenu()
	end
	hook.Remove("HUDPaint","SpawnSelectTeam")
end)
net.Receive("Cheats:CHDeathr", function() hook.Run('CHDeathr', GM); end)
net.Receive("Cheats:RoundMsg", function() local msg = net.ReadString(); hook.Call('RoundMsg', GM, msg); end)
net.Receive("Cheats:RoundStart", function()
	local red, blue = net.ReadInt(8), net.ReadInt(8)
	RoundStarted = true
end)
net.Receive("Cheats:GameStop", function() RoundStarted = false; end)
net.Receive("Cheats:GameWin", function() RoundStarted = false; end)
net.Receive("Cheats:TeamMsg", function()
	local msg, color = net.ReadString(), net.ReadColor()
	hook.Call('TeamMsg', GM, msg, {r = color.r, g = color.g, b = color.b, a = 255} )
end)
net.Receive("Cheats:TeamMenu", TeamMenu)
net.Receive("Cheats:RoundWin", function() hook.Call("RoundWin"); end)
net.Receive("Cheats:RoundLoss", function() hook.Call("RoundLoss"); end)
net.Receive("Cheats:RoundTie", function() hook.Call("RoundTie"); end)
net.Receive("Cheats:GameLobby", function()
	local time = net.ReadInt(8)
	hook.Call("GameLobby", time)
end)

-- ^^^^^^^^ what was the point of these again?

hook.Add("CreateClientsideRagdoll","begoneTHOT",function(entit,rag) rag:SetSaveValue( "m_bFadingOut", true ) end)
