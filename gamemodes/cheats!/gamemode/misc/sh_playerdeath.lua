if SERVER then
	util.AddNetworkString("PlayerDeath")
	util.AddNetworkString("PlayerKill")
	hook.Add("PlayerDeath","CHDeath",function( victim, inflictor, attacker )
		if(victim == attacker or attacker == Entity(0))then
			net.Start("PlayerDeath")
			net.WriteTable({true})
			net.Send(victim)
		else
			net.Start("PlayerDeath")
			net.WriteTable({ attacker, inflictor })
			net.Send(victim)
		end

		net.Start("PlayerKill")
		net.WriteTable({victim})
		net.Send(attacker)

	end)
end

if CLIENT then
	net.Receive("PlayerDeath", function()
		local args = net.ReadTable()
		if(args[1] == true)then
			hook.Call("CHDeath", GAMEMODE, true)
		else
			hook.Call("CHDeath", GAMEMODE, args[1]:Name(), args[2].PrintName)
		end
	end)
	net.Receive("PlayerKill", function()
		local args = net.ReadTable()
		hook.Call("CHKill",GM,args[1]:Name())
	end)
end
