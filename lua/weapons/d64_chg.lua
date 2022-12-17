SWEP.PrintName = "Chaingun"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/w_chg.mdl"

SWEP.Weight = 10
SWEP.Slot = 2
SWEP.SlotPos = 2

SWEP.HoldType = "shotgun"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_Pistol")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.DefaultClip = 70
SWEP.Primary.MinDamage = 4
SWEP.Primary.MaxDamage = 16
SWEP.Primary.Spread = 0.02
SWEP.Primary.Delay = 0.1
SWEP.BulletNum = 1
SWEP.TakeAmmo = 1
SWEP.BulletForce = 5
SWEP.ViewPunch = -1

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("ent/w_weapons/mguna0")
	killicon.Add("d64_chg", "ent/w_weapons/mguna0", Color(255, 255, 255, 255))
end

function SWEP:Initialize()
	self:SetState(1)
	self:SetHoldType(self.HoldType)
	self:SetNWBool("Deploy", false)
	self:SetNWInt("OffsetX", 0)
	self:SetNWInt("OffsetY", 0)
end

function SWEP:PrimaryAttack()
	if (self:Ammo1() < self.TakeAmmo && self.Primary.Ammo != "none") or !self:GetNWBool("Deploy") then
		return
	end
	self:Shoot()
	self:EmitSound(self.Primary.Sound)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SetState(State)
	self:SetNWInt("CurSprite", State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/chg/CHGGA0.png")
        self:SetNWInt("NextState", 2)
        self:SetNWFloat("NextTime", CurTime() + 0.08) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/chg/CHGGB0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.08) 
		self:SetNWInt("OffsetX", math.random(-10, 10))
		self:SetNWInt("OffsetY", math.random(-10, 10))	
    end
end

local CurOffsetX, CurOffsetY = 0, 0

function SWEP:DrawHUD()
	if (self.Owner:InVehicle()) then
		return
	end
	
	local SpriteSize = ScrH() / 256

    if ((input.IsMouseDown(MOUSE_LEFT) or self:GetNextPrimaryFire() - CurTime() > 0) && (self:Ammo1() > self.TakeAmmo or self.Primary.Ammo == "none")) then
		if (self:Ammo1() > 0) then
			self.BobSpeed = 0
			CurOffsetX = math.Approach(CurOffsetX, self:GetNWInt("OffsetX"), 2)
			CurOffsetY = math.Approach(CurOffsetY, self:GetNWInt("OffsetY"), 2)
		else
			self:SetState(1)
		end
	else
		self:SetState(1)
		self.BobSpeed = self.Owner:GetVelocity():Length2D() / self.Owner:GetRunSpeed() * ScrH() / 20
		if self.Owner:GetVelocity():Length2D() >= self.Owner:GetRunSpeed() then
			self.BobSpeed  = ScrH() / 20
		end
		CurOffsetX, CurOffsetY = 0, 0
	end

	local CurMaterial = Material(self:GetNWString("CurSprite"))
	surface.SetMaterial(CurMaterial)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(ScrW() / 2 - CurMaterial:Width() * SpriteSize / 2 + CurOffsetX + math.cos(self.Bob) * self.BobSpeed, 
		ScrH() - CurMaterial:Height() * 0.95 * SpriteSize + math.abs(math.sin(self.Bob)) * self.BobSpeed + CurOffsetY + (self.WeaponPos * ScrH() / 2), 
		CurMaterial:Width() * SpriteSize, 
		CurMaterial:Height() * SpriteSize)
end