SWEP.PrintName = "Shotgun"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Weight = 10
SWEP.Slot = 3
SWEP.SlotPos = 2

SWEP.HoldType = "shotgun"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_Shotgun")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.MinDamage = 4
SWEP.Primary.MaxDamage = 16
SWEP.Primary.Spread = 0.04
SWEP.Primary.Delay = 1
SWEP.BulletNum = 7
SWEP.BulletForce = 2
SWEP.ViewPunch = -2

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/sg/SHT1A0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.3) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/sg/SHT1B0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.4) 
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/sg/SHT1C0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.3) 
    end
end