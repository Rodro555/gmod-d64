AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"

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
			self:GetPhysicsObject():SetVelocity(self:GetForward() * 5000)
		end
		if self:WaterLevel() > 0 then
			self:Remove()
		end
	end
	self:NextThink(0.01)
	return true
end

function ENT:PhysicsCollide()
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
    local DifAngle = math.atan2(self:GetPos().y - self.Owner:GetPos().y, self:GetPos().x - self.Owner:GetPos().x)
    local CurMaterial = Material(self:GetNWString("CurSprite")) 
    render.DrawQuadEasy(self:GetPos(), Vector(0, 0, 1), CurMaterial:Width() * 5, CurMaterial:Height(), Color(255, 255, 255), (DifAngle * 57.2958) - 90)
end

scripted_ents.Register(ENT, "d64_unmakerlsr")