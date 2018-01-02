AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "ICU-2000"
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true
SWEP.SetHoldType = "ar2"
SWEP.Weight = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DrawCustomCrosshair = true
SWEP.ViewModelFlip = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.m_WeaponDeploySpeed = 5
SWEP.CSMuzzleFlashes = true
SWEP.Scoped = false
SWEP.CanScope = true
SWEP.Sens = 1
SWEP.ShouldDropOnDie = false

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.Spread = 0.03

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.ShowESP = false
SWEP.ESPCheck = false
SWEP.ESPTimer = 0

local shoot = Sound("weapons/awp/awp1.wav")

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:Deploy()
	self.ShowESP = false
	self.ESPCheck = false
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
		Tracer = 0,
		Damage = 200,
		AmmoType = self.Primary.Ammo,
		Attacker = ply,
		HullSize = 0,
		Force = 10
	}

	self:FireBullets(Bullet)

	self:EmitSound(shoot)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+1.5)
	ply:ViewPunch(Angle(-1,math.Rand(-0.5,0.5),0))

	ply:SetAmmo(999,"SMG1")

	ply:LagCompensation(false)

	if (CLIENT and !LocalPlayer():ShouldDrawLocalPlayer())then
		ParticleEffectAttach("akmflashmain",PATTACH_POINT_FOLLOW,self:GetOwner():GetViewModel(),1)--viewmodel only
	else
		ParticleEffectAttach("akmflashmain",PATTACH_POINT_FOLLOW,self,1)--world model only
	end
end

function SWEP:FireAnimationEvent( pos, ang, event, options ) -- disable default muzzleflashes
	if ( event == 5003 ) then return true end
	if ( event == 5013 ) then return true end
	if ( event == 5023 ) then return true end
	if ( event == 5033 ) then return true end
	if ( event == 5001 ) then return true end
	if ( event == 5011 ) then return true end
	if ( event == 5021 ) then return true end
	if ( event == 5031 ) then return true end
end

function SWEP:AdjustMouseSensitivity()
	return self.Sens
end

function SWEP:SecondaryAttack()
	if (!self.Scoped and self.CanScope)then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),100,200)
		self.Scoped = true
		self.CanScope = false
		timer.Simple(0.5,function()
			self.CanScope = true
		end)
	elseif(self.Scoped and self.CanScope)then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),200,350)
		self.Scoped = false
		self.CanScope = false
		timer.Simple(0.5,function()
			self.CanScope = true
		end)
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	GAMEMODE:SetPlayerSpeed(self:GetOwner(),200,350)
	self.Scoped = false
	self.Owner:SetFOV( 0, 0 )
	self.Sens = 1
end

function SWEP:Holster()
	GAMEMODE:SetPlayerSpeed(self:GetOwner(),200,350)
	self.ShowESP = false
	self.ESPCheck = false
	return true
end

function SWEP:Think()
	if(!self.ESPCheck)then
		self.ESPCheck = true
		self.ESPTimer = CurTime()
	end
	if((CurTime()-self.ESPTimer)>1.2)then
		self.ShowESP = true
	end
	local vel = self:GetOwner():GetVelocity():Length()/15
	if(self.Scoped)then
		self.Primary.Spread = math.Clamp((vel/200)-0.02,0,9999)

		self.Owner:SetFOV( 20, 0 )
		self.Sens = 0.2
	elseif(!self.Scoped)then
		self.Primary.Spread = (vel/5)+0.3

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
	if self.ShowESP then
		for k,v in pairs(playerpos) do
			local col = team.GetColor(LocalPlayer():Team())

			local pos
			local compare

			if(IsValid(v[1]) and v[1]:IsDormant())then
				pos = v[2]:ToScreen()
				compare = (v[2]+Vector(0,0,1)):ToScreen()
			elseif(IsValid(v[1]) and !v[1]:IsDormant())then
				pos = v[1]:LocalToWorld(v[1]:OBBCenter()):ToScreen()
				compare = (v[1]:LocalToWorld(v[1]:OBBCenter())+Vector(0,0,1)):ToScreen()
			end

			if (IsValid(v[1]) and (v[1] != LocalPlayer()) and v[1]:Alive() and v[1]:Team() != 0) then
				if(v[1]:Team() == 3 or (v[1]:Team() != LocalPlayer():Team()))then

					local size = math.Distance(pos.x,pos.y,compare.x,compare.y)*40
					local hitpos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
					
					if(self.Scoped)then
						hitpos = {x = ScrW()/2,y = ScrH()/2}
					end

					if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)))then
						DrawFancyLine(hitpos.x,hitpos.y,pos.x,pos.y,col.r,col.g,col.b)
					end
					

					if(((pos.x < ScrW() and pos.y < ScrH()) and (pos.x > 0 and pos.y > 0)))then

						surface.SetFont("ESPFont1")
						surface.SetTextColor(col.r,col.g,col.b,255)
						surface.SetTextPos(pos.x-size/2,pos.y+size)
						local txt = ""
						if(IsValid(v[1]:GetActiveWeapon()) and v[1]:GetActiveWeapon():GetClass() == "weapon_bunnyclaw")then
							txt = "Bunny's Claw"
						elseif(IsValid(v[1]:GetActiveWeapon()) and v[1]:GetActiveWeapon():GetClass() == "weapon_icu")then
							txt = "ICU-2000"
						elseif(IsValid(v[1]:GetActiveWeapon()) and v[1]:GetActiveWeapon():GetClass() == "weapon_autoaim_kalashnikov")then
							txt = "Autoaim Kalashnikov-47"
						elseif(IsValid(v[1]:GetActiveWeapon()))then
							txt = v[1]:GetActiveWeapon():GetClass()
						end
						surface.DrawText(v[1]:Health().."/100")
						surface.SetFont("ESPFont2")
						surface.SetTextPos(pos.x-size/2,pos.y+size+15)

						surface.DrawText(txt)

						surface.SetDrawColor(col.r,col.g,col.b,10)
						surface.DrawRect(pos.x-size/2,pos.y-size,size,size*2)
						surface.SetDrawColor(col.r,col.g,col.b,255)
						surface.DrawOutlinedRect(pos.x-size/2,pos.y-size,size,size*2)
					end
				end
			end
		end
	end

	local mat1 = Material("gmod/scope")
	if (self.Scoped) then
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,ScrW()/2-(ScrH()+ScrH()/4)/2,ScrH())
		surface.DrawRect(ScrW()-(ScrW()/2-(ScrH()+ScrH()/4)/2),0,ScrW()/2-(ScrH()+ScrH()/4)/2,ScrH())

		surface.SetMaterial(mat1)

		surface.DrawTexturedRect( ScrW()/2-(ScrH()+ScrH()/4)/2, 0, ScrH()+ScrH()/4, ScrH() )
	end
end