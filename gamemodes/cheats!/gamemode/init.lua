AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("misc/crosshair.lua")
AddCSLuaFile("misc/quickswitch.lua")
AddCSLuaFile("misc/sh_playerdeath.lua")
AddCSLuaFile("misc/anticheat_cl.lua")
AddCSLuaFile("ui/hud.lua")
AddCSLuaFile("ui/teammenu.lua")
AddCSLuaFile("ui/teamgraphics.lua")
AddCSLuaFile("ui/roundgraphics.lua")
AddCSLuaFile("ui/spawneffect.lua")
AddCSLuaFile("ui/targetid.lua")
AddCSLuaFile("ui/killnotif.lua")
AddCSLuaFile("ui/deathnotif.lua")
AddCSLuaFile("misc/particles.lua")
AddCSLuaFile("misc/damageoverlay.lua")

include("misc/spec.lua")
include("misc/chatcommands.lua")
include("shared.lua")
include("misc/rounds.lua")
include("misc/teamfuncs.lua")
include("misc/sh_playerdeath.lua")
include("misc/anticheat_sv.lua")
include("ui/teammenu.lua")
include("misc/particles.lua")
include("misc/damageoverlay.lua")

util.AddNetworkString("Cheats:CHDeathr")
util.AddNetworkString("Cheats:RoundMsg")
util.AddNetworkString("Cheats:GameStop")
util.AddNetworkString("Cheats:RoundStart")
util.AddNetworkString("Cheats:GameLobby")
util.AddNetworkString("Cheats:GameWin")
util.AddNetworkString("Cheats:RoundWin")
util.AddNetworkString("Cheats:RoundLoss")
util.AddNetworkString("Cheats:RoundTie")
util.AddNetworkString("Cheats:RoundEnd")
util.AddNetworkString("Cheats:TeamMsg")
util.AddNetworkString("Cheats:TeamMenu")
util.AddNetworkString("Cheats:DamageOverlay")

SetGlobalBool("Deathmatch",true)
SetGlobalInt("Voteamount",0)

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

function GM:PlayerDeath(ply,ent,attacker)
	if(GetGlobalBool("Deathmatch") or GetGlobalBool("Lobby"))then
		timer.Simple(3,function()
			if(IsValid(ply))then
				ply:Spawn()
			end
		end)
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	dmginfo:ScaleDamage(1)
end

function GM:ShouldCollide( ent1, ent2 )
	if ent1:IsPlayer() or ent2:IsPlayer() then return false end
	
	return true
end

function GM:PlayerSpawn(ply)
	ply.SpecTarget = 1
	net.Start("Cheats:CHDeathr")
	net.Send(ply)
	if(ply:Team() != 0)then
		ply:UnSpectate()
		--ply:SetTeam(math.random(1, 2))
		ply:GiveAmmo(99999999, "SMG1", true)
		hook.Call( "PlayerLoadout", GAMEMODE, ply )
	else
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

function GM:PlayerDeathThink(ply)
	if(!GetGlobalBool("Deathmatch") and !GetGlobalBool("Lobby"))then
		return false
	else
		return true
	end
end

function GM:PlayerLoadout(ply)
	ply:Give("weapon_autoaim_kalashnikov")
	ply:Give("weapon_icu")
	ply:Give("weapon_bunnyclaw")
	return true
end

function GM:PlayerInitialSpawn( ply )
	ply.CheatTimer = CurTime()
	if(ply:IsBot())then
		ply:SetTeam(3)
		ply:SetModel(table.Random(PlayerModels))
	else
		ply:SetTeam(0)
		ply:SetModel(table.Random(PlayerModels))
	end
end

function GM:CanPlayerSuicide(ply)
	if(ply:Alive() and ply:Team() != 0)then
		return (GetGlobalBool("Deathmatch") or GetGlobalBool("Lobby"))
	end
end

function GM:GetFallDamage(ply)
	if(ply:GetActiveWeapon():GetClass() == "weapon_bunnyclaw")then
		return 0
	else 
		return 10
	end
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if((ply:IsPlayer() and attacker:IsPlayer()) and ply:Team() == attacker:Team() and ply:Team() != 3)then
		return false
	else
		return true
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

hook.Add("PlayerDisconnected","VoteCheck",function(ply)
	if(ply:GetNWBool("Voted"))then
		SetGlobalInt("Voteamount",GetGlobalInt("Voteamount")-1)
	end
	if(100*GetGlobalInt("Voteamount")/(table.Count(player.GetAll())-1) > 75)then
		GameLobby()
		SetGlobalBool("Deathmatch",false)
		SetGlobalInt("Voteamount",0)
		for k,v in pairs(player.GetAll())do
			v:SetNWBool("Voted",false)
		end
	end
end)

RunConsoleCommand( "sv_sticktoground","0" )
RunConsoleCommand( "sv_airaccelerate","1000" )
RunConsoleCommand( "sv_gravity","900" )
