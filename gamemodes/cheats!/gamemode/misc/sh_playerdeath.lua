if SERVER then
  util.AddNetworkString("PlayerDeath")
  
  function GM:PlayerDeath( victim, inflictor, attacker )
    net.Start("PlayerDeath")
    net.WriteTable({ victim, inflictor, attacker })
    net.Broadcast()
  end
else
  net.Receive("PlayerDeath", function()
    local args = net.ReadTable()
    
    hook.Call("PlayerDeath", GM, args[1], args[2], args[3])
  end)
end
