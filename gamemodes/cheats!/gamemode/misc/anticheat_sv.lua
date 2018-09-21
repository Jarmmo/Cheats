util.AddNetworkString("anticheat")

net.Receive("anticheat", function(len,ply)
	ply.CheatTimer = CurTime()
	local bool = net.ReadBool()
	if (!GetConVar("sv_allowcslua"):GetBool() and bool == true) then
		ply:Kick("This is not HVH. You do not need to bring your own cheats.")
		print("[CH] "..v:GetName().." has been kicked for cheating")
	end
end)

timer.Create("CHAntiCheatTimer",30,0,function() -- if a cheat blocks the anticheat net message or something
	for k,v in pairs(player.GetAll())do
		if (CurTime()-v.CheatTimer > 30 and !v:IsBot())then
			v:Kick("This is not HVH. You do not need to bring your own cheats.")
			print("[CH] "..v:GetName().." has been kicked for cheating")
		end
	end
end)
