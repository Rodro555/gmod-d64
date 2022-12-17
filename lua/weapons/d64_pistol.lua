SWEP.PrintName = "Pistol"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/w_pistol.mdl"

SWEP.Weight = 10
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.HoldType = "pistol"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_Pistol")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.MinDamage = 4
SWEP.Primary.MaxDamage = 16
SWEP.Primary.Spread = 0.03
SWEP.Primary.Delay = 0.4
SWEP.BulletDistance = 2048

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("ent/w_weapons/pisga0")
	killicon.Add("d64_pistol", "ent/w_weapons/pisga0", Color(255, 255, 255, 255))
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/pistol/PISGA0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/pistol/PISGB0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/pistol/PISGC0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    end
end