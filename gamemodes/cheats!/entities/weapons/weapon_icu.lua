AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "ICU-2000"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "ar2"
SWEP.Weight = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.DrawCustomCrosshair = true
SWEP.DrawHud = false
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

SWEP.Primary.ClipSize = 12
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

function SWEP:Deploy()
	if (SERVER) then
		self:GetOwner():EmitSound("npc/sniper/reload1.wav")
	end
	self.Sens = 1
	self.Scoped = false
	self.CanScope = true
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
		Damage = 50,
		AmmoType = self.Primary.Ammo,
		Attacker = ply,
		HullSize = 0,
		Force = 10
	}

	self:FireBullets(Bullet)
	self:ShootEffects()

	self:EmitSound(shoot)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+1.2)
	ply:ViewPunch(Angle(-1,math.Rand(-0.5,0.5),0))

	ply:LagCompensation(false)

end

function SWEP:AdjustMouseSensitivity()
	return self.Sens
end

function SWEP:SecondaryAttack()
	if (!self.Scoped and self.CanScope)then
		--self:SetNextSecondaryFire(0.5)
		self.Scoped = true
		self.CanScope = false
		timer.Simple(0.5,function()
			self.CanScope = true
		end)
	elseif(self.Scoped and self.CanScope)then
		--self:SetNextSecondaryFire(0.5)
		self.Scoped = false
		self.CanScope = false
		timer.Simple(0.5,function()
			self.CanScope = true
		end)
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self.Scoped = false
	self.Owner:SetFOV( 0, 0 )
	self.Sens = 1
end

function SWEP:Think()
	self.DrawHud = true
	local vel = self:GetOwner():GetVelocity():Length()/15
	if(self.Scoped)then
		self.Primary.Spread = math.Clamp((vel/200)-0.005,0,9999)

		self.Owner:SetFOV( 25, 0 )
		self.Sens = 0.2
	elseif(!self.Scoped)then
		self.Primary.Spread = (vel/50)+0.5

		self.Owner:SetFOV( 0, 0 )
		self.Sens = 1
	end
	return
end

local playerpos = {}

net.Receive("ESP_POS",function()
	playerpos = net.ReadTable()
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

function SWEP:Holster()
	self.DrawHud = false
	return true
end

if !CLIENT then return end

local function CreateFont()
	surface.CreateFont( "ESPFont1", {
		font = "Roboto Cn",
		extended = true,
		size = 20,
		weight = 500,
		antialias = true
	})

	surface.CreateFont( "ESPFont2", {
		font = "Roboto Cn",
		extended = true,
		size = 15,
		weight = 800,
		antialias = true
	})
end
CreateFont() -- create font twice just in case 

function SWEP:DrawHUD()
	if !self.DrawHud then return end

	local mat1 = Material("gmod/scope")
	--local mat2 = Material("gmod/scope-refract") figure this shit out

	if (self.Scoped) then
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,ScrW()/2-(ScrH()+ScrH()/4)/2,ScrH())
		surface.DrawRect(ScrW()-(ScrW()/2-(ScrH()+ScrH()/4)/2),0,ScrW()/2-(ScrH()+ScrH()/4)/2,ScrH())
		
		surface.SetMaterial(mat1)

		surface.DrawTexturedRect( ScrW()/2-(ScrH()+ScrH()/4)/2, 0, ScrH()+ScrH()/4, ScrH() )
	end

	for k,v in pairs(playerpos) do
		if ((v[1] != LocalPlayer()) and (v[1]:IsDormant())) then --dormant
			local hitpos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
			local pos = v[2]:ToScreen()
			if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)) and !self.Scoped)then
				DrawFancyLine(hitpos.x,hitpos.y,pos.x,pos.y,255,100,100)
			end
			local compare = (v[2]+Vector(0,0,1)):ToScreen()
			local size = math.Distance(pos.x,pos.y,compare.x,compare.y)*40

			if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)))then

				surface.SetFont("ESPFont1")
				surface.SetTextColor(255,100,100,255)
				surface.SetTextPos(pos.x-size/2,pos.y+size)
				surface.DrawText(v[1]:GetName())
				surface.SetFont("ESPFont2")
				surface.SetTextPos(pos.x-size/2,pos.y+size+15)
				surface.DrawText(v[1]:Health().."/100")

				surface.SetDrawColor( 255,100,100, 10)
				surface.DrawRect(pos.x-size/2,pos.y-size,size,size*2)
				surface.SetDrawColor( 255,100,100, 255)
				surface.DrawOutlinedRect(pos.x-size/2,pos.y-size,size,size*2)
			end
		elseif((v[1] != LocalPlayer()) and not (v[1]:IsDormant()))then --not
			local hitpos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
			local pos = v[1]:LocalToWorld(v[1]:OBBCenter()):ToScreen()
			if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)) and !self.Scoped)then
				DrawFancyLine(hitpos.x,hitpos.y,pos.x,pos.y,255,100,100)
			end
			local compare = (v[1]:LocalToWorld(v[1]:OBBCenter())+Vector(0,0,1)):ToScreen()
			local size = math.Distance(pos.x,pos.y,compare.x,compare.y)*40

			if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)))then
				surface.SetFont("ESPFont1")
				surface.SetTextColor(255,100,100,255)
				surface.SetTextPos(pos.x-size/2,pos.y+size)
				surface.DrawText(v[1]:GetName())
				surface.SetFont("ESPFont2")
				surface.SetTextPos(pos.x-size/2,pos.y+size+15)
				surface.DrawText(v[1]:Health().."/100")

				surface.SetDrawColor( 255,100,100, 10)
				surface.DrawRect(pos.x-size/2,pos.y-size,size,size*2)
				surface.SetDrawColor( 255,100,100, 255)
				surface.DrawOutlinedRect(pos.x-size/2,pos.y-size,size,size*2)
			end
		end
	end
end