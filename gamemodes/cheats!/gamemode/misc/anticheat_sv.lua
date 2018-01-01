util.AddNetworkString("anticheat")

net.Recieve("anticheat", function()
	local ply = net.ReadEntity()
	local bool = net.ReadBool()
	if bool == true then
		ply:Kick("You really need more cheats? I already supply you with some. What more do you ask?")
	end
end)