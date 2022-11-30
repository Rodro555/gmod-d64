SWEP.PrintName = "Fist"
SWEP.Category = "DOOM 64"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 10
SWEP.Slot = 0
SWEP.SlotPos = 3

SWEP.HoldType = "pistol"
SWEP.Base = "d64_base"

SWEP.Primary.Sound = Sound("nil")
SWEP.Primary.Ammo = "none"
SWEP.Primary.MinDamage = 3
SWEP.Primary.MaxDamage = 24
SWEP.Primary.Spread = 0
SWEP.Primary.Delay = 0.5
SWEP.BulletDistance = 80
SWEP.ViewPunch = 0

function SWEP:Shoot()
    local bullet = {}
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(self.Primary.Spread, self.Primary.Spread, 0)
	bullet.Tracer = 0
	bullet.AmmoType = self.Primary.Ammo
	bullet.Damage = math.Rand(self.Primary.MinDamage, self.Primary.MaxDamage)
	bullet.Num = self.BulletNum
	bullet.Force = self.BulletForce
	bullet.Distance = self.BulletDistance
    bullet.Callback =
    function(attacker, tr, dmg)
        if tr.Hit then
            if tr.Entity:IsNPC() || tr.Entity:IsPlayer() then
                self:EmitSound("DOOM64_Fist") 
            else 
                self:EmitSound("DOOM64_FistMiss") 
            end
        end
    end
	self.Owner:FireBullets(bullet)
	self:TakePrimaryAmmo(self.TakeAmmo)
end

function SWEP:SetState(State)
    self:SetNWInt("CurState", State)
    if State == 1 then
        self:SetNWString("CurSprite", "null")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.15) 
    elseif State == 2 then
        self:SetNWString("CurSprite", "v_spr/fist/PUNGB0.png")
        self:SetNWInt("NextState", 3)
        self:SetNWFloat("NextTime", CurTime() + 0.15) 
    elseif State == 3 then
        self:SetNWString("CurSprite", "v_spr/fist/PUNGC0.png")
        self:SetNWInt("NextState", 4)
        self:SetNWFloat("NextTime", CurTime() + 0.15) 
    elseif State == 4 then
        self:SetNWString("CurSprite", "v_spr/fist/PUNGD0.png")
        self:SetNWInt("NextState", 5)
        self:SetNWFloat("NextTime", CurTime() + 0.15) 
    elseif State == 5 then
        self:SetNWString("CurSprite", "v_spr/fist/PUNGC0.png")
        self:SetNWInt("NextState", 6)
        self:SetNWFloat("NextTime", CurTime() + 0.15)
    elseif State == 6 then
        self:SetNWString("CurSprite", "v_spr/fist/PUNGB0.png")
        self:SetNWInt("NextState", 1)
        self:SetNWFloat("NextTime", CurTime() + 0.15)
    end
end

function SWEP:DrawHUD()
	local SpriteSize = ScrH() / 256
	if ((input.IsMouseDown(MOUSE_LEFT) or self:GetNextPrimaryFire() - CurTime() > 0) && (self:Ammo1() > 1 or self.Primary.Ammo == "none")) then
		self.BobSpeed = 0
	else
		self.BobSpeed = self.Owner:GetVelocity():Length2D() / self.Owner:GetRunSpeed() * ScrH() / 20
	end

	local CurMaterial = Material(self:GetNWString("CurSprite"))
	surface.SetMaterial(CurMaterial)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(ScrW() / 2 - CurMaterial:Width() * SpriteSize / 2 - ScrW() * 1/10 + math.cos(self.Bob) * self.BobSpeed, 
		ScrH() - CurMaterial:Height() * SpriteSize + math.abs(math.sin(self.Bob)) * self.BobSpeed + (self.WeaponPos * ScrH() / 2), 
		CurMaterial:Width() * SpriteSize, 
		CurMaterial:Height() * SpriteSize)
    
    if (self:GetNWInt("CurState") == 1) then
        CurMaterial = Material("v_spr/fist/PUNGA0.png")
        surface.SetMaterial(CurMaterial)
        surface.DrawTexturedRect(ScrW() / 2 - CurMaterial:Width() * SpriteSize / 2 + ScrW() * 1/10 + math.cos(self.Bob) * self.BobSpeed, 
		ScrH() - CurMaterial:Height() * SpriteSize + math.abs(math.sin(self.Bob)) * self.BobSpeed + (self.WeaponPos * ScrH() / 2), 
		CurMaterial:Width() * SpriteSize, 
		CurMaterial:Height() * SpriteSize) 
    end
end