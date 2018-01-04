local function Wierd()
	net.Start("anticheat")
	if (GetConVar("sv_allowcslua") == nil or (IsValid(GetConVar("sv_allowcslua")) and GetConVar("sv_allowcslua"):GetBool() == true)) then
		net.WriteBool(true)
	else
		net.WriteBool(false)
	end
	net.SendToServer()
	timer.Simple(1,Wierd)
end
Wierd()