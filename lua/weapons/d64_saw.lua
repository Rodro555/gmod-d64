SWEP.PrintName = "Saw"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 10
SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.HoldType = "pistol"
SWEP.Base = "d64_base"

SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "none"
SWEP.Primary.MinDamage = 4
SWEP.Primary.MaxDamage = 16
SWEP.Primary.Spread = 0
SWEP.Primary.Delay = 0.1
SWEP.BulletDistance = 80
SWEP.ViewPunch = 0

function SWEP:Deploy()
	self:SetNWBool("Deploy", true)
	self:EmitSound("DOOM64_SAW1")
end

function SWEP:PrimaryAttack()
	if self:Ammo1() < 1 && self.Primary.Ammo != "none" then
		return
	end
	self:Shoot()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetState(3)
	timer.Simple(0.2, function()
		self:SetState(1)
	end)
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGA0.png")
        self:SetNWInt("NextState", 2)
        self:SetNWFloat("NextTime", CurTime() + 0.2)
		self:EmitSound("DOOM64_SAW2")
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGB0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
		self:EmitSound("DOOM64_SAW2")
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGC0.png")
        self:SetNWInt("NextState", 4)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
		self:EmitSound("DOOM64_SAW3")
    elseif State == 4 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGD0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.1)
		self:EmitSound("DOOM64_SAW3")
    end 
end