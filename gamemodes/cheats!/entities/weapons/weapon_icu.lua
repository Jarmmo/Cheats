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
SWEP.CSMuzzleFlashes = false
SWEP.Scoped = false
SWEP.Sens = 1
SWEP.ShouldDropOnDie = false

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.Spread = 0.3
SWEP.Primary.Damage = 200

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ShowESP = false
SWEP.ESPCheck = false
SWEP.ESPTimer = 0

SWEP.AccTimeex = 0

local shoot = Sound("weapons/awp/awp1.wav")

function SWEP:ShootTracer(startp,endp)
if CLIENT then
	local ply = self:GetOwner()
	local time = SysTime()
	local tag = "CH_ICUTRACER_"..ply:SteamID().."_"..math.Rand(0,100)
	local col = team.GetColor(LocalPlayer():Team())
	local matr = Material("trails/smoke")
	hook.Add("PreDrawEffects",tag,function()
		local timeex = SysTime()-time

		render.SetMaterial(matr)
		render.DrawBeam(startp,endp,math.Clamp(10-timeex*10,0,10),1,0,Color(col.r,col.g,col.b,math.Clamp(255-timeex*255,0,255)))

		if(timeex > 4)then
			hook.Remove("PreDrawEffects",tag)
		end
	end)
else

end
end

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:Deploy()
	self.ShowESP = false
	self.ESPCheck = false
	if SERVER then
		self:GetOwner():EmitSound("npc/sniper/reload1.wav")
	end
	self.Sens = 1
	self.Scoped = false
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
		Damage = self.Primary.Damage,
		AmmoType = self.Primary.Ammo,
		Attacker = ply,
		HullSize = 1,
		Force = 10
	}

	self:FireBullets(Bullet)

	self:EmitSound(shoot)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+1.5)
	ply:ViewPunch(Angle(-1,math.Rand(-0.5,0.5),0))

	ply:SetAmmo(999,"SMG1")

	if (CLIENT and !LocalPlayer():ShouldDrawLocalPlayer())then
		if(IsValid(self:GetOwner():GetViewModel()) and IsFirstTimePredicted())then
			ParticleEffectAttach("CH_akmflashfp",PATTACH_POINT_FOLLOW,self:GetOwner():GetViewModel(),1) --viewmodel only
			if(self.Primary.Spread == 0)then
				self:ShootTracer(self:GetOwner():EyePos()-Vector(0,0,10),ply:GetEyeTrace().HitPos)
				local effect = nil
				if(ply:Team() == 1)then
					effect = CreateParticleSystem(Entity(0),"CH_icutracer_red",PATTACH_ABSORIGIN,1,self:GetOwner():EyePos()-Vector(0,0,10))
					CreateParticleSystem(Entity(0),"CH_icuhit_red",PATTACH_ABSORIGIN,1,ply:GetEyeTrace().HitPos)

				elseif(ply:Team() == 2)then
					effect = CreateParticleSystem(Entity(0),"CH_icutracer_blue",PATTACH_ABSORIGIN,1,self:GetOwner():EyePos()-Vector(0,0,10))
					CreateParticleSystem(Entity(0),"CH_icuhit_blue",PATTACH_ABSORIGIN,1,ply:GetEyeTrace().HitPos)

				elseif(ply:Team() == 3)then
					effect = CreateParticleSystem(Entity(0),"CH_icutracer_green",PATTACH_ABSORIGIN,1,self:GetOwner():EyePos()-Vector(0,0,10))
					CreateParticleSystem(Entity(0),"CH_icuhit_green",PATTACH_ABSORIGIN,1,self:GetOwner():GetEyeTrace().HitPos)
				end

				if(effect != nil)then
					effect:AddControlPoint(1,Entity(0),PATTACH_ABSORIGIN,0,ply:GetEyeTrace().HitPos)
				end
			end
		end
		if(IsValid(self:GetOwner():GetViewModel()))then
			timer.Simple(0,function()
				if(IsValid(self:GetOwner():GetViewModel()))then
					self:GetOwner():GetViewModel():StopParticlesNamed("CH_muzzlesmoke")
					ParticleEffectAttach("CH_muzzlesmoke",PATTACH_POINT_FOLLOW,self:GetOwner():GetViewModel(),1)
				end
			end)
		end
	else
		ParticleEffectAttach("CH_akmflashtp",PATTACH_POINT_FOLLOW,self,1) --world model only
	end
	ply:LagCompensation(false)
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
	if (!self.Scoped and IsFirstTimePredicted())then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),100,200)
		self.AccTimeex = SysTime()
		local tag = "CH_ICUspread_"..self:GetOwner():Name()
		timer.Remove(tag)
		hook.Add("Think",tag,function()
			if(!IsValid(self))then return end
			self.Primary.Spread = math.Clamp(0.5-(SysTime()-self.AccTimeex)/1.5,0,0.5)
			self.Primary.Damage = math.Clamp((SysTime()-self.AccTimeex)*250,0,200)
		end)
		timer.Create(tag,3,1,function()
			hook.Remove("Think",tag)
		end)
		self.Scoped = true
	elseif(self.Scoped and IsFirstTimePredicted())then
		self.Primary.Spread = 0.3
		self.Primary.Damage = 200
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),200,350)
		self.Scoped = false
		hook.Remove("Think","CH_ICUspread_"..self:GetOwner():Name())
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	GAMEMODE:SetPlayerSpeed(self:GetOwner(),200,350)
	self.Scoped = false
	self.Owner:SetFOV( 0, 0 )
	self.Sens = 1
	self.Primary.Spread = 0.3
	self.Primary.Damage = 500
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
		self.Owner:SetFOV( 20, 0 )
		self.Sens = 0.2
	elseif(!self.Scoped)then
		self.Owner:SetFOV( 0, 0 )
		self.Sens = 1
		self.Primary.Spread = 0.3
		self.Primary.Damage = 200
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
						if(v[1]:Crouching())then
							surface.SetDrawColor(col.r,col.g,col.b,10)
							surface.DrawRect(pos.x-size/2,pos.y-size,size,size)
							surface.SetDrawColor(col.r,col.g,col.b,255)
							surface.DrawOutlinedRect(pos.x-size/2,pos.y-size,size,size)
						else
							surface.SetDrawColor(col.r,col.g,col.b,10)
							surface.DrawRect(pos.x-size/2,pos.y-size,size,size*2)
							surface.SetDrawColor(col.r,col.g,col.b,255)
							surface.DrawOutlinedRect(pos.x-size/2,pos.y-size,size,size*2)
						end
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