SWEP.PrintName = "Plasma Rifle"
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
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Delay = 0.13

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("ent/w_weapons/plsma0")
	killicon.Add("d64_plasmaball", "ent/w_weapons/plsma0", Color(255, 255, 255, 255))
end

local SoundTime = 0  
function SWEP:Deploy()
	self:SetNWBool("Deploy", true)
	SoundTime = 0
end

function SWEP:Holster(Weapon)
	if (!IsValid(Weapon)) then
		return false
	end
	self:SetNWBool("Deploy", false)
	if (!self.ShouldSwitch) then
		self.ShouldSwitch = true
		self.WeaponSwitch = Weapon
		self:SetNWFloat("SwitchTime", CurTime() + 0.5)
	else
		self.ShouldSwitch = false
		self.WeaponSwitch = nil
		self:SetNWFloat("SwitchTime", 0)
		SoundTime = CurTime() + 1000
		self:StopSound("DOOM64_PlasmaIdle")
		self:StopSound("DOOM64_PlasmaShoot")
		return true
	end
end

local PTick = 0
function SWEP:Think()
	if (CurTime() > self:GetNWFloat("NextTime")) then
		self:SetState(self:GetNWInt("NextState"))
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
	
	if (CurTime() > SoundTime && CurTime() > self:GetNextPrimaryFire() && !self.Owner:InVehicle()) then
		self:EmitSound("DOOM64_PlasmaIdle")
		SoundTime = CurTime() + 0.5
	end

	PTick = CurTime()
end

function SWEP:PrimaryAttack()
	if (self:Ammo1() < self.TakeAmmo && self.Primary.Ammo != "none") or !self:GetNWBool("Deploy") then
		return
	end
	self:Shoot()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetState(4)
	if SERVER then
		self:EmitSound("DOOM64_PlasmaShoot")
	end
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
    self.Owner:SetAnimation(PLAYER_ATTACK1)
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