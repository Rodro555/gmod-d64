SWEP.PrintName = "Base"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 10
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.UseHands = false
SWEP.HoldType = "none"
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Base = "weapon_base"

SWEP.Primary.Sound = nil;
SWEP.Primary.ClipSize = -1
SWEP.Primary.MaxAmmo = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.MinDamage = 0
SWEP.Primary.MaxDamage = 0
SWEP.Primary.Spread = 0
SWEP.Primary.Delay = 0
SWEP.BulletDistance = 2048

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.SpriteSize = 0
SWEP.Bob = 0
SWEP.BobSpeed = 0
SWEP.ShouldSwitch = false

SWEP.WeaponPos = 1
SWEP.ShouldSwitch = false
SWEP.WeaponSwitch = nil
SWEP.SwitchWeapon = true

SWEP.BulletNum = 1
SWEP.TakeAmmo = 1
SWEP.BulletForce = 1
SWEP.ViewPunch = -1
SWEP.BackVel = 0

function SWEP:Initialize()
	self:SetState(1)
	self:SetNWBool("Deploy", false)
end

function SWEP:Deploy()
	self:SetNWBool("Deploy", true)
end

function SWEP:Holster(Weapon)
	self:SetNWBool("Deploy", false)
	if (!self.ShouldSwitch) then
		self.ShouldSwitch = true
		self.WeaponSwitch = Weapon
		self:SetNWFloat("SwitchTime", CurTime() + 0.5)
	else
		self.ShouldSwitch = false
		self.WeaponSwitch = nil
		self:SetNWFloat("SwitchTime", 0)
		return true
	end
end

local PTick = 0

function SWEP:Think()
	if (CurTime() > self:GetNWFloat("NextTime")) then
		self:SetState(self:GetNWInt("NextState"))
	end

	local Delta = CurTime() - PTick
	if (self.Bob >= 2 * math.pi) then
		self.Bob = 0
	end

	self.Bob = math.Approach(self.Bob, 2 * math.pi, Delta * 3)

	if self:GetNWBool("Deploy") then
		self.WeaponPos = math.Approach(self.WeaponPos, 0, Delta * 3)
	else
		self.WeaponPos = math.Approach(self.WeaponPos, 1, Delta * 3)
	end

	if (CurTime() > self:GetNWFloat("SwitchTime") && self:GetNWFloat("SwitchTime") != 0 && SERVER) then
		self.Owner:SelectWeapon(self.WeaponSwitch)
	end

	PTick = CurTime()
end

function SWEP:PrimaryAttack()
	if (self:Ammo1() < self.TakeAmmo && self.Primary.Ammo != "none") or !self:GetNWBool("Deploy") then
		return
	end
	self:Shoot()
	self:EmitSound(self.Primary.Sound)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetState(2)
end

function SWEP:Shoot()
    local bullet = {}
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(self.Primary.Spread, self.Primary.Spread, 0)
	bullet.Tracer = 0
	bullet.AmmoType = self.Primary.Ammo
	bullet.Damage = math.Rand(self.Primary.MinDamage, self.Primary.MaxDamage)
	bullet.Num = self.BulletNum
	bullet.Force = self.BulletForce
	bullet.Distance = self.BulletDistance
	self.Owner:FireBullets(bullet)
	self:TakePrimaryAmmo(self.TakeAmmo)
	self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
	self.Owner:SetVelocity(-self.Owner:GetForward() * self.BackVel)
end

function SWEP:DrawHUD()
	local SpriteSize = ScrH() / 256
	if ((input.IsMouseDown(MOUSE_LEFT) or self:GetNextPrimaryFire() - CurTime() > 0) && (self:Ammo1() > self.TakeAmmo or self.Primary.Ammo == "none")) then
		self.BobSpeed = 0
	else
		self.BobSpeed = self.Owner:GetVelocity():Length2D() / self.Owner:GetRunSpeed() * ScrH() / 20
		if self.Owner:GetVelocity():Length2D() >= self.Owner:GetRunSpeed() then
			self.BobSpeed  = ScrH() / 20
		end
	end

	local CurMaterial = Material(self:GetNWString("CurSprite"))
	local GunHeight = CurMaterial:Height()
	surface.SetMaterial(CurMaterial)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(ScrW() / 2 - CurMaterial:Width() * SpriteSize / 2 + math.cos(self.Bob) * self.BobSpeed, 
		ScrH() - CurMaterial:Height() * SpriteSize + math.abs(math.sin(self.Bob)) * self.BobSpeed + (self.WeaponPos * ScrH() / 2), 
		CurMaterial:Width() * SpriteSize, 
		CurMaterial:Height() * SpriteSize)
end