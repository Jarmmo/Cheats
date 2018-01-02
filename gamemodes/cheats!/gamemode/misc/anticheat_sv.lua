util.AddNetworkString("anticheat")

net.Receive("anticheat", function(len,ply)
	local bool = net.ReadBool()
	if (!GetConVar("sv_allowcslua"):GetBool() and bool == true) then
		ply:Kick("This is not hvh. You do not need to bring your own cheats")
	end
end)