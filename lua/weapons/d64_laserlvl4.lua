SWEP.PrintName = "Unmaker Level 4"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.Base = "d64_laserlvl3"
SWEP.Slot = 4
SWEP.SlotPos = 7

local LaserOffset = 0
function SWEP:Shoot()
    if not SERVER then return end
    LaserOffset = LaserOffset + 1
    if (LaserOffset > 4) then
        LaserOffset = 1
    end
    for i = -1, 1, 1 do 
        local ent = ents.Create("d64_unmakerlsr")
        ent:SetOwner(self.Owner)
        ent:SetPos(self.Owner:GetShootPos() - self.Owner:EyeAngles():Up() * 8)
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()
        local AimVector = self.Owner:GetAimVector()
        AimVector:Rotate(Angle(0, i * LaserOffset * 3, 0))
        ent:GetPhysicsObject():SetVelocity(AimVector * 5000)
        self:TakePrimaryAmmo(self.TakeAmmo)
        self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
    end
end
