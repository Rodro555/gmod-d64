SWEP.PrintName = "Unmaker Level 1"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 10
SWEP.Slot = 4
SWEP.SlotPos = 4

SWEP.HoldType = "pistol"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_Laser")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.MinDamage = 10
SWEP.Primary.MaxDamage = 80
SWEP.Primary.Spread = 0.04
SWEP.Primary.Delay = 0.3
SWEP.BulletDistance = 2048
SWEP.ViewPunch = 0

local NextSoundTime = CurTime()

function SWEP:PrimaryAttack()
	if self:Ammo1() < 1 && self.Primary.Ammo != "none" then
		return
	end
	self:Shoot()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetState(2)

    if (CurTime() > NextSoundTime) then
        self:EmitSound("DOOM64_Laser") 
        NextSoundTime = CurTime() + 0.2
    end
end

function SWEP:Shoot()
    local ent = ents.Create("d64_unmakerlsr")
    ent:SetOwner(self.Owner)
    ent:SetPos(self.Owner:GetShootPos() - self.Owner:EyeAngles():Up() * 8)
    ent:SetAngles(self.Owner:EyeAngles())
    ent:Spawn()
    ent:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 5000)
    self:TakePrimaryAmmo(self.TakeAmmo)
    self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
end


function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/lsr/LASRA0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/lsr/LASRB0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
    end
end