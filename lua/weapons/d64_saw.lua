SWEP.PrintName = "Saw"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/w_saw.mdl"

SWEP.Weight = 10
SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.HoldType = "shotgun"
SWEP.Base = "d64_base"

SWEP.Primary.MaxAmmo = 200
SWEP.Primary.Ammo = "none"
SWEP.Primary.MinDamage = 3
SWEP.Primary.MaxDamage = 24
SWEP.Primary.Spread = 0
SWEP.Primary.Delay = 0.1
SWEP.BulletDistance = 80
SWEP.ViewPunch = 0

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("ent/w_weapons/csawa0")
	killicon.Add("d64_saw", "ent/w_weapons/csawa0", Color(255, 255, 255, 255))
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetIdleState(1)
	self:SetNWBool("Deploy", false)
    self:SetNWBool("Firing", false)
end

-- GOD, this was pain. fucking animations.

local PTick = 0
function SWEP:Think()
    if (CurTime() > self:GetNWFloat("NextTime")) then
        if (self:GetNWBool("Firing")) then
            self:SetState(self:GetNWInt("NextState")) 
        else
            self:SetIdleState(self:GetNWInt("NextState")) 
        end
    end 

	local Delta = CurTime() - PTick
	if (self.Bob >= 2 * math.pi) then
		self.Bob = 0
	end

	self.Bob = math.Approach(self.Bob, 2 * math.pi, Delta * 3)

	if self:GetNWBool("Deploy") then
		self.WeaponPos = math.Approach(self.WeaponPos, 0, Delta * 3)
	else
		self.WeaponPos = math.Approach(self.WeaponPos, 1, Delta * 3)
	end

	if (CurTime() > self:GetNWFloat("SwitchTime") && self:GetNWFloat("SwitchTime") != 0 && SERVER && IsValid(self.WeaponSwitch)) then
		self.Owner:SelectWeapon(self.WeaponSwitch)
	end

	PTick = CurTime()
end


function SWEP:PrimaryAttack()
	if (self:Ammo1() < self.TakeAmmo && self.Primary.Ammo != "none") or !self:GetNWBool("Deploy") then
		return
	end
	self:Shoot()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNWBool("Firing", true)
end

function SWEP:SetIdleState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGA0.png")
        self:SetNWInt("NextState", 2)
        self:SetNWFloat("NextTime", CurTime() + 0.2) 
        if (!IsFirstTimePredicted() && !self.Owner:InVehicle()) then
            self:EmitSound("DOOM64_SAW2") 
        end
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGB0.png")
        self:SetNWFloat("NextTime", CurTime() + 0.2)
        self:SetNWInt("NextState", 1) 
        if (!IsFirstTimePredicted() && !self.Owner:InVehicle()) then
            self:EmitSound("DOOM64_SAW2") 
        end
    end
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGC0.png")
        self:SetNWInt("NextState", 2)
        self:SetNWFloat("NextTime", CurTime() + 0.1) 
        if (!IsFirstTimePredicted() && !self.Owner:InVehicle()) then
            self:EmitSound("DOOM64_SAW3") 
        end
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/saw/SAWGD0.png")
        self:SetNWFloat("NextTime", CurTime() + 0.1)
        self:SetNWInt("NextState", 1) 
        if (!IsFirstTimePredicted() && !self.Owner:InVehicle()) then
            self:EmitSound("DOOM64_SAW3") 
        end
        if (CurTime() > self:GetNextPrimaryFire() + 0.1) then
            self:SetNWBool("Firing", false)
        end
    end
end