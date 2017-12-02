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
	if !SERVER then return end

	local ply = self:GetOwner()
	ply:LagCompensation(true)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	ply:SetAnimation(PLAYER_ATTACK1)
	ply:EmitSound(shoot)

	self:SetNextPrimaryFire(CurTime()+0.1)

	ply:LagCompensation(false)
end

local SnapAim = false

function SWEP:Think()
	if !CLIENT then return end
	if(self:GetOwner():KeyPressed(IN_ATTACK))then
		SnapAim = true
	end
	if(self:GetOwner():KeyReleased(IN_ATTACK))then
		SnapAim = false
	end
end

local function CheckFOV(target,PixelDifference)
	local W,H = ScrW()/2,ScrH()/2
	local ScreenPos = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Head1")):ToScreen()
	local Dist = Vector(W,H,0):Distance(Vector(ScreenPos.x,ScreenPos.y,0))
	if Dist < PixelDifference then 
		return true
	end
	return false
end

function FindNearestEntity(pos, range )
	local nearestEnt;
	for k, v in pairs(ents.GetAll()) do
		if (v != LocalPlayer() and (v:IsPlayer() or v:IsNPC()))then
			local distance = pos:Distance(v:GetPos());
			if(distance <= range)then
				nearestEnt = v;
				range = distance;
			end
		end
	end
	return nearestEnt;
end

hook.Add("Think","AIMBOT",function()
	if !CLIENT then return end

	if !SnapAim then return end

	if(not LocalPlayer():GetActiveWeapon():GetClass() == "weapon_autoaim_kalashnikov") then return end
	local ply = LocalPlayer()

	local target = FindNearestEntity(ply:GetPos(),500)

	if (IsValid(target)and(target:IsPlayer() or target:IsNPC()) and (CheckFOV(target,300))) then
		local targetheadpos = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Head1"))
		ply:SetEyeAngles((targetheadpos - ply:EyePos()):Angle())
	end
end)

function SWEP:SecondaryAttack()
	if !CLIENT then return end
end