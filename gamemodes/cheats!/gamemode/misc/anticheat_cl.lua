function Wierd()
	net.Start("anticheat")
	net.WriteEntity(LocalPlayer())
	net.WriteBool(GetConVar("sv_allowcslua"):GetInt() >= 1 and true or false) --ALLOWCSLUA
	net.SendToServer()
	timer.Simple(.25, Wierd)
end

Wierd()