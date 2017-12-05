AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Autoaim Kalashnikov-47"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "ar2"
SWEP.Weight = 2
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.DrawCustomCrosshair = true
SWEP.ViewModelFlip = true
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.m_WeaponDeploySpeed = 1
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

	ply:LagCompensation(false)
end

function SWEP:CanSecondaryAttack()
	return false
end


function SWEP:Think()
	local vel = self:GetOwner():GetVelocity():Length()/15
	if(self:GetOwner():Crouching())then
		self.Primary.Spread = (vel/250)+0.02
	else
		self.Primary.Spread = (vel/25)+0.025
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

local function CheckFOV(target,PixelDifference)
	local W,H = ScrW()/2,ScrH()/2
	local ScreenPos = target:GetBonePosition(target:LookupBone(targetbone)):ToScreen()
	local ScreenCompare = (target:GetBonePosition(target:LookupBone(targetbone))+Vector(0,0,1)):ToScreen()
	local Dist = Vector(W,H,0):Distance(Vector(ScreenPos.x,ScreenPos.y,0))
	local pd = (math.Distance(ScreenPos.x,ScreenPos.y,ScreenCompare.x,ScreenCompare.y)*PixelDifference)/2
	if Dist < pd then 
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
local PlaySound = true

hook.Add("CreateMove","AIMBOT",function(asd)
	if (input.IsButtonDown(MOUSE_RIGHT))then
		SnapAim = true
	elseif (!input.IsButtonDown(MOUSE_RIGHT))then
		SnapAim = false
		PlaySound = true
	end

	if (SnapAim) then
		local wep = LocalPlayer():GetActiveWeapon()
		if(IsValid(wep) and wep:GetClass() == "weapon_autoaim_kalashnikov") then
			local ply = LocalPlayer()

			local target = FindNearestToCrosshair()

			if (IsValid(target)and((target:IsPlayer()and target:Alive()) or (target:IsNPC() and target:Health() >= 0)) and (CheckFOV(target,200) and CheckLOS(target))) then
				if (PlaySound) then
					surface.PlaySound("ui/buttonclick.wav")
					PlaySound = false
				end
				local targetbonepos = target:GetBonePosition(target:LookupBone(targetbone))
				asd:SetViewAngles((targetbonepos - ply:EyePos()):Angle())
			end
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
	local wep = LocalPlayer():GetActiveWeapon()
	if(IsValid(wep) and wep:GetClass() == "weapon_autoaim_kalashnikov") then
		for k,target in pairs(ents.GetAll())do
			if (IsValid(target)and(target:IsPlayer() or (target:IsNPC() and target:Health() >= 0)) and target != LocalPlayer() and CheckLOS(target)) then
				local targetipos = target:GetBonePosition(target:LookupBone(targetbone))
				local targetcompare = (targetipos+Vector(0,0,1)):ToScreen()
				local sizeb = math.Distance(targetipos:ToScreen().x,targetipos:ToScreen().y,targetcompare.x,targetcompare.y)*15
				local pos = targetipos:ToScreen()

				if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)))then
					surface.SetDrawColor(255,100,100,80)
					surface.DrawRect(pos.x-sizeb/2,pos.y-sizeb/2,sizeb,sizeb)
					surface.DrawOutlinedRect(pos.x-sizeb/2,pos.y-sizeb/2,sizeb,sizeb)
				end

				local atarget = FindNearestToCrosshair()
				if (IsValid(atarget)and(atarget:IsPlayer() or atarget:IsNPC()))then
					local atargetipos = atarget:GetBonePosition(atarget:LookupBone(targetbone)):ToScreen()
					if(CheckFOV(atarget,200)and CheckLOS(atarget)and !SnapAim)then

						local hitpos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()

						DrawFancyLine(hitpos.x,hitpos.y,atargetipos.x,atargetipos.y,255,100,100)

					end
				end
			end
		end
	end
end)
