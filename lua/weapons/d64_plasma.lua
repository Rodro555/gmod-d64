SWEP.PrintName = "Plama Rifle"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/w_pls.mdl"

SWEP.Weight = 10
SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.HoldType = "shotgun"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("DOOM64_PlasmaShoot")
SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "AR2AltFire"
SWEP.Primary.Delay = 0.13

function SWEP:Deploy()
	self:SetNWBool("Deploy", true)
    self:EmitSound("DOOM64_PlasmaIdle")
    timer.Create("SndMgr", 2, 0, function()
        if (!self.Owner:InVehicle()) then
            self:EmitSound("DOOM64_PlasmaIdle") 
        end
    end)
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
        timer.Stop("SndMgr")
        timer.Remove("SndMgr")
		return true
	end
end


function SWEP:PrimaryAttack()
	if (self:Ammo1() < self.TakeAmmo && self.Primary.Ammo != "none") or !self:GetNWBool("Deploy") then
		return
	end
	self:Shoot()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetState(4)

    timer.Stop("SndMgr")
    self:EmitSound("DOOM64_PlasmaShoot")
    timer.Simple(0.5, function()
        if (self.Owner:KeyDown(IN_ATTACK)) then
            self:EmitSound("DOOM64_PlasmaShoot") 
        else
            self:EmitSound("DOOM64_PlasmaIdle")
            timer.Start("SndMgr") 
        end
    end)
end

function SWEP:Shoot()
	local ent = ents.Create("d64_plasmaball")
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() - self.Owner:EyeAngles():Up() * 8)
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
	ent:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 2000)
	self:TakePrimaryAmmo(self.TakeAmmo)
    self.Owner:ViewPunch(Angle(self.ViewPunch, 0, 0))
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/pls/PLASA0.png")
        self:SetNWInt("NextState", 2)
        self:SetNWFloat("NextTime", CurTime() + 0.05) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/pls/PLASB0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.05) 
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/pls/PLASC0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.05) 
    elseif State == 4 then
        self:SetNWString("CurSprite", "v_spr/pls/PLASD0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
    end
end