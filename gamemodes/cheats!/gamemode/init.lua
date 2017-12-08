AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("misc/crosshair.lua")
AddCSLuaFile("misc/quickswitch.lua")
AddCSLuaFile("misc/votemap.lua")

include("misc/votemap.lua")
include("shared.lua")
include("misc/rounds.lua")


local PlayerModels = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl"
}

function GM:PlayerSpawn( ply )
	if(ply:Team() != 0)then
		ply:UnSpectate()
		--ply:SetTeam(math.random(1, 2))
		ply:GiveAmmo(99999999, "SMG1", true)
		hook.Call( "PlayerLoadout", GAMEMODE, ply )
	elseif(ply:Team() == 0)then
		ply:Spectate(OBS_MODE_ROAMING)
		ply:GodEnable()
	end
	local col = team.GetColor(ply:Team())
	timer.Simple(0,function()
		ply:SetModel(table.Random(PlayerModels))
		ply:SetPlayerColor(Vector(col.r/255,col.g/255,col.b/255))
	end)
	ply:SetJumpPower(300)
	ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end

function GM:PlayerLoadout(ply)
	ply:Give("weapon_autoaim_kalashnikov")
	ply:Give("weapon_icu")
	ply:Give("weapon_bunnyclaw")
	return true
end

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(0)
	ply:SetModel(table.Random(PlayerModels))
end

function GM:CanPlayerSuicide(ply)
	if(ply:Alive() and ply:Team() != 0)then
		ply:Kill()
	end
end

function GM:KeyPress(ply)
	if(!ply:Alive())then
		ply:Spawn()
	end
end

function GM:PostPlayerDeath(ply)
	timer.Simple(0,function()
		ply:Spawn()
		ply:SetPlayerColor(Vector(255,0,0))
	end)
end

function GM:GetFallDamage(ply)
	if(ply:GetActiveWeapon():GetClass() == "weapon_bunnyclaw")then
		return 0
	else 
		return 10
	end
end

util.AddNetworkString("ESP_POS")

local last = 0

function GM:Think()
	local playertable = {}
	local weptable = {}
	if(table.Count(player.GetAll()) <= 0)then return end
	for k,v in pairs(player.GetAll())do
		table.insert(playertable,{v,v:LocalToWorld(v:OBBCenter())})
	end
	for k,v in pairs(player.GetAll())do
		if(IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "weapon_icu")then
			table.insert(weptable,v)
		end
	end
	if((table.Count(playertable) <= 0) or (table.Count(weptable) <= 0))then return end

	local delay = 0.5

	if CurTime() - last > delay then
		net.Start("ESP_POS")
		net.WriteTable(playertable)
		net.Send(weptable)
		last = CurTime()
	end
end

hook.Add("PlayerSay","chatcommands",function(ply,text)
	if(string.StartWith(text,"!team"))then
		local teams = team.GetAllTeams()
		tc1 = table.Count(team.GetPlayers(1))
		tc2 = table.Count(team.GetPlayers(2))
		if(ply:Team() == 1)then
			tc1 = tc1-1
		elseif(ply:Team() == 2)then
			tc2 = tc2-1
		end
		if(tc1>tc2 and ply:Team() != 2)then
			ply:SetTeam(2)
			ply:Kill()
			ply:ChatPrint("Set team to Blue")
		elseif(tc1<tc2 and ply:Team() != 1)then
			ply:SetTeam(1)
			ply:Kill()
			ply:ChatPrint("Set team to Red")
		elseif(tc1==tc2)then
			local teamr = math.random(1, 2)
			ply:SetTeam(teamr)
			ply:ChatPrint("Set team to ".. team.GetName(teamr))
			ply:Kill()
		end
		return ""
	end
end)

RunConsoleCommand( "sv_sticktoground","0" )
RunConsoleCommand( "sv_airaccelerate","1000" )
RunConsoleCommand( "sv_gravity","900" )