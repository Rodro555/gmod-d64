SWEP.PrintName = "Rocket Launcher"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/w_rck.mdl"

SWEP.Weight = 10
SWEP.Slot = 4
SWEP.SlotPos = 2

SWEP.HoldType = "shotgun"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_Rocket")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.Delay = 0.6
SWEP.BackVel = 100

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("ent/w_weapons/launa0")
	killicon.Add("d64_rocketproj", "ent/w_weapons/launa0", Color(255, 255, 255, 255))
end

function SWEP:Shoot()
	local ent = ents.Create("d64_rocketproj")
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() - self.Owner:EyeAngles():Up() * 8)
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
	ent:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 2000)
	self:TakePrimaryAmmo(self.TakeAmmo)
    self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
	self.Owner:SetVelocity(-self.Owner:GetForward() * self.BackVel)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/rck/ROCKA0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/rck/ROCKB0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/rck/ROCKC0.png")
        self:SetNWInt("NextState", 4)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    elseif State == 4 then
        self:SetNWString("CurSprite", "v_spr/rck/ROCKD0.png")
        self:SetNWInt("NextState", 5)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    elseif State == 5 then
        self:SetNWString("CurSprite", "v_spr/rck/ROCKE0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    end
end