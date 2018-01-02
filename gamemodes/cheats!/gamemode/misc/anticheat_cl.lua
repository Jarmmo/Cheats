local function Wierd()
	net.Start("anticheat")
	net.WriteBool(GetConVar("sv_allowcslua"):GetBool()) --ALLOWCSLUA
	net.SendToServer()
	timer.Simple(1,Wierd)
end
Wierd()