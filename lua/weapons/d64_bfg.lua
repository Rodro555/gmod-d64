SWEP.PrintName = "BFG9000"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 10
SWEP.Slot = 4
SWEP.SlotPos = 3

SWEP.HoldType = "pistol"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_BFGShoot")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "AR2AltFire"
SWEP.Primary.Delay = 1.5
SWEP.TakeAmmo = 40
SWEP.ViewPunch = -5

function SWEP:Shoot()
    timer.Simple(1, function()
        local ent = ents.Create("d64_bfgball")
        ent:SetOwner(self.Owner)
        ent:SetPos(self.Owner:GetShootPos() - self.Owner:EyeAngles():Up() * 8)
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()
        ent:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 1500)
        self:TakePrimaryAmmo(self.TakeAmmo)
        self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
    end)
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/bfg/BFGGB0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1)
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/bfg/BFGGB0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.5)  
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/bfg/BFGGC0.png")
        self:SetNWInt("NextState", 4)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
    elseif State == 4 then
        self:SetNWString("CurSprite", "v_spr/bfg/BFGGD0.png")
        self:SetNWInt("NextState", 5)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
    elseif State == 5 then
        self:SetNWString("CurSprite", "v_spr/bfg/BFGGE0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
    end
end