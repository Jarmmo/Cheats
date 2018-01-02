util.AddNetworkString("anticheat")

net.Receive("anticheat", function(len,ply)
	local bool = net.ReadBool()
	if (!GetConVar("sv_allowcslua"):GetBool() and bool == true) then
		local msg = {
			"This is not HVH. You do not need to bring your own cheats.",
			"Cheats gamemode doesn't mean you can use your cheats here.",
			"Kicked for enabling other cheats.",
			"Look Stanley, I think perhaps we've gotten off on the wrong foot here."
		}
		local val = table.Random(msg)
		ply:Kick(val)
	end
end)
