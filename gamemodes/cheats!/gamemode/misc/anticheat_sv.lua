util.AddNetworkString("anticheat")

local anticheatmsg = {
	"This is not HVH. You do not need to bring your own cheats.",
	"Cheats gamemode doesn't mean you can use your cheats here.",
	"Kicked for enabling other cheats.",
	"Look Stanley, I think perhaps we've gotten off on the wrong foot here."
}

net.Receive("anticheat", function(len,ply)
	ply.CheatTimer = CurTime()
	local bool = net.ReadBool()
	if (!GetConVar("sv_allowcslua"):GetBool() and bool == true) then
		ply:Kick(table.Random(anticheatmsg))
		print("[CH] "..v:GetName().." has been kicked for cheating")
	end
end)

timer.Create("CHAntiCheatTimer",30,0,function() -- if a cheat blocks the anticheat net message or something
	for k,v in pairs(player.GetAll())do
		if (CurTime()-v.CheatTimer > 10 and !v:IsBot())then
			v:Kick(table.Random(anticheatmsg))
			print("[CH] "..v:GetName().." has been kicked for cheating")
		end
	end
end)