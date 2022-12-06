AddCSLuaFile()

ENT.PrintName = "Base"
ENT.Category = "DOOM 64"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AdminOnly = false

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Weapon = ""
ENT.Sprite = ""
ENT.AmmoType = ""
ENT.Ammo = 0
ENT.IsWeapon = true

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:DrawShadow(false)
		self:SetTrigger(true)
	end
end

function ENT:Draw()
	local Mat = Material(self.Sprite)
	render.SetMaterial(Mat)
	render.DrawSprite(self:GetPos(), Mat:Width(), Mat:Height(), Color(255, 255, 255, 255))
end

function ENT:Touch(entity)
	if SERVER && entity:IsPlayer() then
		if (self.IsWeapon) then
			entity:GiveAmmo(self.Ammo, self.AmmoType, true)
			if (entity:HasWeapon(self.Weapon)) then
				self:EmitSound("DOOM64_ItemPickup")
			else 
				entity:Give(self.Weapon)
				self:EmitSound("DOOM64_WeaponPickup")	
			end
			self:Remove()
		else
			self:EmitSound("DOOM64_ItemPickup")
			entity:GiveAmmo(self.Ammo, self.AmmoType, true)
		end
	end
end