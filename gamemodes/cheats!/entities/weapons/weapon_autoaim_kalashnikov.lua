AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Autoaim Kalashnikov-47"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "ar2"
SWEP.Weight = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DrawCustomCrosshair = true
SWEP.ViewModelFlip = true
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.m_WeaponDeploySpeed = 5
SWEP.CSMuzzleFlashes = true

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.Spread = 0.03

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.ShouldDropOnDie = false

local shoot = Sound("weapons/ak47/ak47-1.wav")

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:PrimaryAttack()
	if (self.Weapon:Clip1() <= 0) then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return
	end

	if (!self:CanPrimaryAttack()) then return end

	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local Bullet = {}

	Bullet.Num = 1
	Bullet.Src = ply:GetShootPos()
	Bullet.Dir = ply:GetAimVector()
	Bullet.Spread = Vector(self.Primary.Spread,self.Primary.Spread,0)
	Bullet.Tracer = 1
	Bullet.Damage = 7+math.Rand(5,10)
	Bullet.Ammotype = self.Primary.Ammo
	Bullet.Attacker = ply
	Bullet.HullSize = 1

	self:FireBullets(Bullet)
	self:ShootEffects()

	self:EmitSound(shoot)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+0.12)
	ply:ViewPunch(Angle(-0.5,math.Rand(-0.5,0.5),0))

	ply:SetAmmo(999,"SMG1")

	ply:LagCompensation(false)
end

function SWEP:CanSecondaryAttack()
	return false
end


function SWEP:Think()
	--local vel = self:GetOwner():GetVelocity():Length()/15
	if(self:GetOwner():Crouching())then
		self.Primary.Spread = 0.02
	else
		self.Primary.Spread = 0.04
	end
	return
end

if !CLIENT then return end

local targetbone = "ValveBiped.Bip01_Head1"

local function CheckLOS(target)
	local pos = target:GetBonePosition(target:LookupBone(targetbone))
	local trace = util.TraceLine({
		start = pos,
		endpos = LocalPlayer():GetShootPos(),
		filter = {LocalPlayer(),target},
		ignoreworld = false
	})

	if(trace.Fraction != 1)then
		return false
	end
	return true
end

local function GetTarget()
	local target = false
	for k,v in pairs(player.GetAll())do
		local pos = v:GetBonePosition(v:LookupBone(targetbone))
		local trace = util.TraceLine({
			start = pos,
			endpos = LocalPlayer():GetShootPos(),
			filter = {LocalPlayer(),v},
			ignoreworld = false
		})

		if(trace.Fraction == 1)then
			if(v:Alive() and v != LocalPlayer() and (v:Team() == 3 or (v:Team() != LocalPlayer():Team())))then
				--local ScreenPos = v:GetBonePosition(v:LookupBone(targetbone)):ToScreen()
				--local Dist = Vector(W,H,0):Distance(Vector(ScreenPos.x,ScreenPos.y,0))

				local lpang = LocalPlayer():EyeAngles()
				local ang = (v:GetBonePosition(v:LookupBone(targetbone)) - LocalPlayer():EyePos()):Angle()
				local ady = math.abs(math.NormalizeAngle(lpang.y - ang.y))
				local adp = math.abs(math.NormalizeAngle(lpang.p - ang.p ))
				if not(ady > 10 or adp > 10) then
					target = v
				end
			end
		end
	end
	return target
end

local SnapAim = false
local Targeting = false
local target = false
local PlaySound = false
local AllowSound = true

hook.Add("Think","AIMBOT",function()

	local wep = LocalPlayer():GetActiveWeapon()
	if(IsValid(wep) and wep:GetClass() != "weapon_autoaim_kalashnikov") then return end

	if(!Targeting)then
		target = GetTarget()
	end

	if(target == false or !target:Alive())then
		Targeting = false
		AllowSound = true
	else
		if(AllowSound)then
			PlaySound = true
			AllowSound = false
		end
		Targeting = true
	end

	if(!Targeting)then
		PlaySound = false
	end

	if(input.IsButtonDown(MOUSE_RIGHT))then
		SnapAim = true
	else
		AllowSound = true
		SnapAim = false
		Targeting = false
		target = false
	end

	if(target != false and !CheckLOS(target))then
		target = false
	end

	if (SnapAim) then
		local ply = LocalPlayer()

		if(PlaySound)then
			surface.PlaySound("ui/buttonclick.wav")
			PlaySound = false
		end

		if((target != false and target:Alive()))then
			local targetbonepos = target:GetBonePosition(target:LookupBone(targetbone))
			LocalPlayer():SetEyeAngles((targetbonepos - ply:EyePos()):Angle())
		end
	end
end)

local function DrawFancyLine(startx,starty,endx,endy,r,g,b)
surface.SetDrawColor(r,g,b,255)
surface.DrawLine( startx, starty, endx, endy)

surface.SetDrawColor(r,g,b,30)
surface.DrawLine( startx+1, starty, endx+1, endy)
surface.DrawLine( startx, starty+1, endx, endy+1)
surface.DrawLine( startx, starty-1, endx, endy-1)
surface.DrawLine( startx-1, starty, endx-1, endy)

surface.SetDrawColor(r,g,b,20)
surface.DrawLine( startx+1, starty+1, endx+1, endy+1)
surface.DrawLine( startx-1, starty+1, endx-1, endy+1)
surface.DrawLine( startx+1, starty-1, endx+1, endy-1)
surface.DrawLine( startx-1, starty-1, endx-1, endy-1)
end

hook.Add("HUDPaint","AIMBOTTARGETINDICATOR",function()
	local col = team.GetColor(LocalPlayer():Team())
	local wep = LocalPlayer():GetActiveWeapon()
	if(IsValid(wep) and wep:GetClass() == "weapon_autoaim_kalashnikov") then
		for k,target in pairs(player.GetAll())do
			if (IsValid(target)and target:Alive() and target:Team() != 0 and target != LocalPlayer() and CheckLOS(target)) then
				if(target:Team() == 3 or (target:Team() != LocalPlayer():Team()))then
					local targetipos = target:GetBonePosition(target:LookupBone(targetbone))
					local targetcompare = (targetipos+Vector(0,0,1)):ToScreen()
					local sizeb = math.Distance(targetipos:ToScreen().x,targetipos:ToScreen().y,targetcompare.x,targetcompare.y)*15
					local pos = targetipos:ToScreen()

					if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)))then
						surface.SetDrawColor(col.r,col.g,col.b,80)
						surface.DrawRect(pos.x-sizeb/2,pos.y-sizeb/2,sizeb,sizeb)
						surface.DrawOutlinedRect(pos.x-sizeb/2,pos.y-sizeb/2,sizeb,sizeb)
					end
				end

				local atarget = GetTarget()
				if (IsValid(atarget)and(atarget:IsPlayer() or atarget:IsNPC()))then
					local atargetipos = atarget:GetBonePosition(atarget:LookupBone(targetbone)):ToScreen()
					if(CheckLOS(atarget)and !SnapAim)then

						local hitpos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()

						DrawFancyLine(hitpos.x,hitpos.y,atargetipos.x,atargetipos.y,col.r,col.g,col.b)

					end
				end
			end
		end
	end
end)