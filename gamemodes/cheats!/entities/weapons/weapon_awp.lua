AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "AWP"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "ar2"
SWEP.Weight = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFlip = true
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.m_WeaponDeploySpeed = 1
SWEP.CSMuzzleFlashes = true
SWEP.Scoped = false
SWEP.CanScope = true
SWEP.Sens = 1

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.Spread = 0.03

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.ShouldDropOnDie = false

local shoot = Sound("weapons/awp/awp1.wav")

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:PrimaryAttack()

	if (!self:CanPrimaryAttack()) then return end

	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local Bullet = {
		Num = 1,
		Src = ply:GetShootPos(),
		Dir = ply:GetAimVector(),
		Spread = Vector(self.Primary.Spread,self.Primary.Spread,0),
		Tracer = 1,
		Damage = 100,
		AmmoType = self.Primary.Ammo,
		Attacker = ply,
	}

	self:FireBullets(Bullet)
	self:ShootEffects()

	self:EmitSound(shoot)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+1.3)
	ply:ViewPunch(Angle(-1,math.Rand(-0.5,0.5),0))

	ply:LagCompensation(false)

end

function SWEP:AdjustMouseSensitivity()
	return self.Sens
end

function SWEP:SecondaryAttack()
	if (!self.Scoped and self.CanScope)then
		self.Owner:SetFOV( 25, 0 )
		self.Sens = 0.2
		self:SetNextSecondaryFire(0.5)
		self.Scoped = true
		self.CanScope = false
		timer.Simple(0.5,function()
			self.CanScope = true
		end)
	elseif(self.Scoped and self.CanScope)then
		self.Owner:SetFOV( 0, 0 )
		self.Sens = 1
		self:SetNextSecondaryFire(0.5)
		self.Scoped = false
		self.CanScope = false
		timer.Simple(0.5,function()
			self.CanScope = true
		end)
	end
end

function SWEP:DrawHUD()
	if (self.Scoped) then
		local TexturedQuadStructure = {
			texture = surface.GetTextureID( "gmod/scope" ),
			color	= Color( 0, 0, 0, 255 ),
			x 	= ScrW()/2-(ScrH()+ScrH()/4)/2,
			y 	= 0,
			w 	= ScrH()+ScrH()/4,
			h 	= ScrH()
		}
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,ScrW()/2-(ScrH()+ScrH()/4)/2,ScrH())
		surface.DrawRect(ScrW()-(ScrW()/2-(ScrH()+ScrH()/4)/2),0,ScrW()/2-(ScrH()+ScrH()/4)/2,ScrH())

		draw.TexturedQuad( TexturedQuadStructure )
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self.Scoped = false
	self.Owner:SetFOV( 0, 0 )
	self.Sens = 1
end

function SWEP:Think()
	local vel = self:GetOwner():GetVelocity():Length()/15
	if(self.Scoped)then
		self.Primary.Spread = math.Clamp((vel/200)-0.005,0,9999)
	else
		self.Primary.Spread = (vel/50)+0.5
	end
	return
end

--self.Primary.Spread = (vel/500)+0.02
--self.Primary.Spread = (vel/50)+0.025