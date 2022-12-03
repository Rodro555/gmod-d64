SWEP.PrintName = "Unmaker Level 3"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.Base = "d64_laserlvl2"

function SWEP:Shoot()
    for i = -1, 1, 2 do 
        local ent = ents.Create("d64_unmakerlsr")
        ent:SetOwner(self.Owner)
        ent:SetPos(self.Owner:GetShootPos() - self.Owner:EyeAngles():Up() * 8)
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()
        local AimVector = self.Owner:GetAimVector()
        AimVector:Rotate(Angle(0, i * 2, 0))
        ent:GetPhysicsObject():SetVelocity(AimVector * 5000)
        self:TakePrimaryAmmo(self.TakeAmmo)
        self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
    end
end
