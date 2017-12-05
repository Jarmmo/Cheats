include("shared.lua")
include("crosshair.lua")
include("quickswitch.lua")

hook.Add("CreateClientsideRagdoll","begoneTHOT",function(entit,rag) rag:SetSaveValue( "m_bFadingOut", true ) end)