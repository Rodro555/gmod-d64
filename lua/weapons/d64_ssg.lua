SWEP.PrintName = "Super Shotgun"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/w_ssg.mdl"

SWEP.Weight = 10
SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.HoldType = "shotgun"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_SSG1")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.DefaultClip = 8
SWEP.Primary.MinDamage = 5
SWEP.Primary.MaxDamage = 15
SWEP.Primary.Spread = 0.1
SWEP.Primary.Delay = 1.5
SWEP.BulletNum = 20
SWEP.TakeAmmo = 2
SWEP.BulletForce = 2
SWEP.ViewPunch = -3
SWEP.BackVel = 100

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("ent/w_weapons/sgn2a0")
	killicon.Add("d64_ssg", "ent/w_weapons/sgn2a0", Color(255, 255, 255, 255))
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/ssg/SHT2A0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1)
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/ssg/SHT2A02.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
        timer.Simple(1, function()
            self:EmitSound("DOOM64_SSG2")
        end)
        timer.Simple(1.2, function()
            self:EmitSound("DOOM64_SSG3")
        end)
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/ssg/SHT2B02.png")
        self:SetNWInt("NextState", 4)
        self:SetNWFloat("NextTime", CurTime() + 1)
    elseif State == 4 then
        self:SetNWString("CurSprite", "v_spr/ssg/SHT2C0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1)
    end
end