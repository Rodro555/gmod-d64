SWEP.PrintName = "Unmaker Level 2"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.Base = "d64_laser"
SWEP.Primary.Delay = 0.15

local NextSoundTime = CurTime()

function SWEP:PrimaryAttack()
	if self:Ammo1() < 1 && self.Primary.Ammo != "none" then
		return
	end
	self:Shoot()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if (CurTime() > NextSoundTime) then
        self:EmitSound("DOOM64_Laser") 
        NextSoundTime = CurTime() + 0.1
    end
end

local PTick = 0
function SWEP:Think()
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

	if (CurTime() > self:GetNWFloat("SwitchTime") && self:GetNWFloat("SwitchTime") != 0 && SERVER) then
		self.Owner:SelectWeapon(self.WeaponSwitch)
	end

	PTick = CurTime()
end

function SWEP:SetState(State)
    if State == 1 then
        self:SetNWString("CurSprite", "v_spr/lsr/LASRA0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.075) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/lsr/LASRB0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.075) 
    end
end

function SWEP:DrawHUD()
	local SpriteSize = ScrH() / 256

    if ((input.IsMouseDown(MOUSE_LEFT) or self:GetNextPrimaryFire() - CurTime() > 0) && (self:Ammo1() > 1 or self.Primary.Ammo == "none")) then
		if (self:Ammo1() > 0) then
			self.BobSpeed = 0
		else
			self:SetState(2)
		end
	else
		self:SetState(1)
		self.BobSpeed = self.Owner:GetVelocity():Length2D() / self.Owner:GetRunSpeed() * ScrH() / 20
	end

	local CurMaterial = Material(self:GetNWString("CurSprite"))
	surface.SetMaterial(CurMaterial)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(ScrW() / 2 - CurMaterial:Width() * SpriteSize / 2 + CurOffsetX + math.cos(self.Bob) * self.BobSpeed, 
		ScrH() - CurMaterial:Height() * 0.95 * SpriteSize + math.abs(math.sin(self.Bob)) * self.BobSpeed + CurOffsetY + (self.WeaponPos * ScrH() / 2), 
		CurMaterial:Width() * SpriteSize, 
		CurMaterial:Height() * SpriteSize)
end