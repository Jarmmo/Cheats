AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


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
	ply:SetModel(table.Random(PlayerModels))
	ply:SetPlayerColor(Vector(200,100,100))	
	ply:SetJumpPower(300)
	ply:GiveAmmo(99999999, "SMG1", true)
	ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	hook.Call( "PlayerLoadout", GAMEMODE, ply )
end

function GM:PlayerLoadout(ply)
	ply:Give("weapon_bunnyclaw")
	ply:Give("weapon_autoaim_kalashnikov")
	return true
end

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam( 1 )
	hook.Call()
end

function GM:CanPlayerSuicide(ply)
	if(ply:Alive())then
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
	end
end

RunConsoleCommand( "sv_sticktoground","0" )
RunConsoleCommand( "sv_airaccelerate","1000" )
RunConsoleCommand( "sv_gravity","900" )

util.AddNetworkString("votemap")
util.AddNetworkString("votemap_vote")

local active = false

local ass = {}
local votings = {}
local votedplayers = {}

function startvote()
	local maps = 0

	for k,v in pairs(file.Find("maps/cs_*.bsp","GAME")) do
		if(maps < 16) then
			table.insert(ass, v)
		end
		maps = maps + 1
	end

	for k,v in pairs(file.Find("maps/de_*.bsp","GAME")) do
		if(maps < 16) then
			table.insert(ass, v)
		end
		maps = maps + 1
	end

	for k,v in pairs(ass) do
		votings[v] = 0
	end

	active = true

	net.Start("votemap")
	net.WriteTable(ass)
	net.Broadcast()

	timer.Simple(30, function()
		active = false
		ass = {}
		votedplayers = {}
		local namemap = ""
		local score = 0

		for k,v in pairs(votings) do
			if(v > score) then
				score = v
				namemap = k
			end
		end

		timer.Simple(5,function()
			if score ~= 0 then
				RunConsoleCommand("changelevel", string.StripExtension( namemap ))
			end
		end)
	end)
end

hook.Add("PlayerSay", "votemap", function(ply,txt)

	if active then
		local exists = false

		for k,v in pairs(votedplayers) do
			if(ply == v) then
				exists = true
			end
		end

		if not exists then
			local yes = tonumber(txt)
			if yes then 
				if ass[yes] then
					votings[ass[yes]] = votings[ass[yes]] + 1
					table.insert(votedplayers, ply)
					net.Start("votemap_vote")
					net.WriteString(ass[yes])
					net.Broadcast()
				end
			end
		end
	end
end)

concommand.Add("votemap",function()
	startvote()
end)
