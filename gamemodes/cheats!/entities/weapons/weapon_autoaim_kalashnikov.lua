AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Autoaim Kalashnikov-47"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "ar2"
SWEP.Weight = 100
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFlip = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.m_WeaponDeploySpeed = 1

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
		return
	end
	local ply = self:GetOwner()

	local Bullet = {}

	Bullet.Num = 1
	Bullet.Src = ply:GetShootPos()
	Bullet.Dir = ply:GetAimVector()
	Bullet.Spread = Vector(self.Primary.Spread,self.Primary.Spread,0)
	Bullet.Tracer = 1
	Bullet.Damage = 30
	Bullet.Ammotype = self.Primary.Ammo
	Bullet.Attacker = ply

	self:FireBullets(Bullet)


	--ply:LagCompensation(true)

	self:TakePrimaryAmmo(1)
	if SERVER then ply:EmitSound(shoot) end
	
	self.Owner:ViewPunch( Angle( -0.5, math.Rand(-0.5,0.5), 0 ) )
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	ply:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime()+0.1)

	--ply:LagCompensation(false)
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:CanPrimaryAttack()
	return IsFirstTimePredicted()
end

if !CLIENT then return end

function SWEP:Think()
	local vel = self:GetOwner():GetVelocity():Length()/15
	if(self:GetOwner():Crouching())then
		self.Primary.Spread = (vel/500)+0.005
	else
		self.Primary.Spread = (vel/50)+0.01
	end
	return
end

local function CheckLOS(target)
	local pos = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Spine2"))
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

local targetbone = "ValveBiped.Bip01_Head1"

local function CheckFOV(target,PixelDifference)
	local W,H = ScrW()/2,ScrH()/2
	local ScreenPos = target:GetBonePosition(target:LookupBone(targetbone)):ToScreen()
	local Dist = Vector(W,H,0):Distance(Vector(ScreenPos.x,ScreenPos.y,0))
	if Dist < PixelDifference then 
		return true
	end
	return false
end

local function FindNearestToCrosshair()
	local nearestEnt
	local LowestDist = 999
	local W,H = ScrW()/2,ScrH()/2
	for k,v in pairs(ents.GetAll())do
		if ((v:IsPlayer() and v:Alive() and v != LocalPlayer()) or v:IsNPC())then
			local ScreenPos = v:GetBonePosition(v:LookupBone(targetbone)):ToScreen()
			local Dist = Vector(W,H,0):Distance(Vector(ScreenPos.x,ScreenPos.y,0))
			if (Dist < LowestDist) then
				LowestDist = Dist
				nearestEnt = v
			end
		end
	end
	return nearestEnt
end

local SnapAim = false

hook.Add("CreateMove","AIMBOT",function(asd)
	if (input.IsButtonDown(MOUSE_RIGHT))then
		SnapAim = true
	elseif (!input.IsButtonDown(MOUSE_RIGHT))then
		SnapAim = false
	end

	if (SnapAim) then
		local wep = LocalPlayer():GetActiveWeapon()
		if(IsValid(wep) and wep:GetClass() == "weapon_autoaim_kalashnikov") then
			local ply = LocalPlayer()

			local target = FindNearestToCrosshair()

			if (IsValid(target)and((target:IsPlayer()and target:Alive()) or target:IsNPC()) and (CheckFOV(target,300) and CheckLOS(target))) then
				local targetbonepos = target:GetBonePosition(target:LookupBone(targetbone))+Vector(0,0,3)
				asd:SetViewAngles((targetbonepos - ply:EyePos()):Angle())
			end
		end
	end
end)

hook.Add("HUDPaint","AIMBOTTARGETINDICATOR",function()
	local wep = LocalPlayer():GetActiveWeapon()
	if(IsValid(wep) and wep:GetClass() == "weapon_autoaim_kalashnikov") then
		for k,target in pairs(ents.GetAll())do
			if (IsValid(target)and(target:IsPlayer() or target:IsNPC()) and target != LocalPlayer() and CheckLOS(target)) then
				local targetipos = target:GetBonePosition(target:LookupBone(targetbone)):ToScreen()
				local sizeb = 13.5
				local sizes = 10.5
				for i = sizeb, sizes, -1 do
					surface.DrawCircle(targetipos.x, targetipos.y, i,0,255,0,100)
				end
				surface.DrawCircle(targetipos.x, targetipos.y, sizeb+0.3,0,255,0,10)
				surface.DrawCircle(targetipos.x, targetipos.y, sizeb+0.5,0,255,0,1)
				local atarget = FindNearestToCrosshair()
				if (IsValid(atarget)and(atarget:IsPlayer() or atarget:IsNPC()))then
					local atargetipos = atarget:GetBonePosition(atarget:LookupBone(targetbone)):ToScreen()
					if(CheckFOV(atarget,300)and CheckLOS(atarget)and !SnapAim)then
						surface.SetDrawColor(0,255,0,255)
						surface.DrawLine( ScrW()/2, ScrH()/2, atargetipos.x, atargetipos.y)
					end
				end
			end
		end
	end
end)