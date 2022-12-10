AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self:SetNWString("CurSprite", "ent/unmakerlsr/BOLTA0.png")
    if SERVER then
        self:SetModel("models/hunter/misc/sphere025x025.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:DrawShadow(false)
        self:SetTrigger(true)
        self:GetPhysicsObject():EnableGravity(false)
    end
end

function ENT:Think()
	if SERVER then
		if IsValid(self:GetPhysicsObject()) then
			self:GetPhysicsObject():SetVelocity(self:GetVelocity() * 5000)
		end
		if self:WaterLevel() > 0 then
			self:Remove()
		end
	end
	self:NextThink(0.01)
	return true
end

function ENT:PhysicsCollide()
	local ent = ents.Create("d64_unmakerspark")
	ent:SetOwner(self.Owner)
	ent:SetPos(self:GetPos())
	ent:SetAngles(Angle(0, 0, 0))
	ent:DrawShadow(false)
	ent:Spawn()
	self:Remove()
end

function ENT:Touch(entity)
	if SERVER && entity != self.Owner then
		local dmg = DamageInfo()
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(25)
		dmg:SetDamageType(DMG_PLASMA)
		dmg:SetDamageForce(self:GetForward())
		entity:TakeDamageInfo(dmg)
		self:PhysicsCollide()
	end
end

function ENT:Draw()
    local CurMaterial = Material(self:GetNWString("CurSprite")) 
	render.SetMaterial(CurMaterial)
	render.DrawBeam(self:GetPos(), self:GetPos() + self:GetVelocity(), 5, 0, 1, Color(255, 255, 255, 255))
end

scripted_ents.Register(ENT, "d64_unmakerlsr")