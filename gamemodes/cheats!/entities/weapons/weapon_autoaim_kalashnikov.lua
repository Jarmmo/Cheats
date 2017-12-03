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
SWEP.DrawCrosshair = true -- this will change, custom crosshair
SWEP.ViewModelFlip = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.m_WeaponDeploySpeed = 0.7

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
	self:SetWeaponHoldType("ar2")
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


	ply:LagCompensation(true)

	self:TakePrimaryAmmo(1)
	if SERVER then ply:EmitSound(shoot) end
	
	self.Owner:ViewPunch( Angle( -0.5, 0, 0 ) )
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	ply:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime()+0.1)

	ply:LagCompensation(false)
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
		self.Primary.Spread = (vel/500)+0.01
	else
		self.Primary.Spread = (vel/50)+0.02
	end
	return
end

local SnapAim = false

if CLIENT then
	hook.Add("KeyPress","FOVAIM_ON",function(ply,key)
		if(!IsValid(ply))then return end
		if(!IsValid(ply:GetActiveWeapon())) then return end
		if(ply:GetActiveWeapon():GetClass() == "weapon_autoaim_kalashnikov" and key == IN_ATTACK)then
			SnapAim = true
		end
	end)
	hook.Add("KeyRelease","FOVAIM_OFF",function(ply,key)
		if(!IsValid(ply))then return end
		if(!IsValid(ply:GetActiveWeapon())) then return end
		if(key == IN_ATTACK)then
			SnapAim = false
		end
	end)
end

local function CheckFOV(target,PixelDifference)
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


	local W,H = ScrW()/2,ScrH()/2
	local ScreenPos = pos:ToScreen()
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
			local ScreenPos = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Spine2")):ToScreen()
			local Dist = Vector(W,H,0):Distance(Vector(ScreenPos.x,ScreenPos.y,0))
			if (Dist < LowestDist) then
				LowestDist = Dist
				nearestEnt = v
			end
		end
	end
	return nearestEnt
end

hook.Add("Think","AIMBOT",function() 
	if !SnapAim then return end

	if(not LocalPlayer():GetActiveWeapon():GetClass() == "weapon_autoaim_kalashnikov") then return end
	local ply = LocalPlayer()

	local target = FindNearestToCrosshair()

	if (IsValid(target)and(target:IsPlayer() or target:IsNPC()) and (CheckFOV(target,300))) then
		local targetbonepos = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Spine2"))+(target:GetVelocity():GetNormalized()*target:GetVelocity():Length()/10)
		ply:SetEyeAngles((targetbonepos - ply:EyePos()):Angle())
	end
end)