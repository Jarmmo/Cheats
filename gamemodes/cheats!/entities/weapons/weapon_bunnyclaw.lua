AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Bunny's Claw"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "knife"
SWEP.Weight = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.ShouldDropOnDie = false

local hitplayer = {
	"weapons/knife/knife_hit1.wav",
	"weapons/knife/knife_hit2.wav",
	"weapons/knife/knife_hit3.wav",
	"weapons/knife/knife_hit4.wav",
}
local miss = {
	"weapons/knife/knife_slash1.wav",
	"weapons/knife/knife_slash2.wav",
}

local hitworld = Sound("weapons/knife/knife_hitwall1.wav")

function SWEP:Initialize()
	self:SetHoldType("knife")
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:PrimaryAttack()

	local ply = self:GetOwner()
	ply:LagCompensation(true)

	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	ply:SetAnimation(PLAYER_ATTACK1)

	if !SERVER then return end

	local shootpos = ply:GetShootPos()
	local hitpos = shootpos + ply:GetAimVector()*75
	local tmin = Vector(1,1,1)*-15
	local tmax = Vector(1,1,1)*15

	local tr = util.TraceHull({
		start = shootpos,
		endpos = hitpos,
		filter = ply,
		mask = MASK_SHOT_HULL,
		mins = tmin,
		maxs = tmax
	})

	local ent = tr.Entity

	if(IsValid(ent) and (ent:IsPlayer()or ent:IsNPC()))then
		ply:EmitSound(Sound(table.Random(hitplayer)))
		ent:TakeDamage(25,ply,self)
	elseif(!IsValid(ent) and ent != Entity(0))then
		ply:EmitSound(Sound(table.Random(miss)))
	else
		ply:EmitSound(hitworld)
	end

	self:SetNextPrimaryFire(CurTime()+0.5)
	self:SetNextSecondaryFire(CurTime()+0.5)

	ply:LagCompensation(false)
end

function SWEP:SecondaryAttack()

	local ply = self:GetOwner()
	ply:LagCompensation(true)

	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	ply:SetAnimation(PLAYER_ATTACK1)
	
	if !SERVER then return end

	local shootpos = ply:GetShootPos()
	local hitpos = shootpos + ply:GetAimVector()*65
	local tmin = Vector(1,1,1)*-15
	local tmax = Vector(1,1,1)*15

	local tr = util.TraceHull({
		start = shootpos,
		endpos = hitpos,
		filter = ply,
		mask = MASK_SHOT_HULL,
		mins = tmin,
		maxs = tmax
	})

	local ent = tr.Entity

	if(IsValid(ent) and (ent:IsPlayer()or ent:IsNPC()))then
		ply:EmitSound(Sound(table.Random(hitplayer)))
		ent:TakeDamage(75,ply,self)
	elseif(!IsValid(ent) and ent != Entity(0))then
		ply:EmitSound(Sound(table.Random(miss)))
	else
		ply:EmitSound(hitworld)
	end

	self:SetNextPrimaryFire(CurTime()+1)
	self:SetNextSecondaryFire(CurTime()+1)

	ply:LagCompensation(false)
end

function SWEP:Think()
	if !CLIENT then return end
	if input.IsKeyDown(KEY_SPACE) and !vgui.CursorVisible() and self:GetOwner():IsOnGround() then
		RunConsoleCommand("+jump")
		timer.Create("BHOP",0,0,function()
			RunConsoleCommand("-jump")
		end)
	end
end
