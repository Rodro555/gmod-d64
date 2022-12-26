AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self:SetNWString("CurSprite", "ent/rocket/MISLA5.png")
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
			self:GetPhysicsObject():SetVelocity(self:GetForward() * 2000)
		end
		if self:WaterLevel() > 0 then
			self:Remove()
		end

        EffectData():SetOrigin(self:GetPos())
		util.Effect("doom64_rocketrail", EffectData())
        self:NextThink(CurTime() + 0.08)
	end
	return true
end

function ENT:Draw()
    local CurMaterial = Material(self:GetNWString("CurSprite")) 
    render.SetMaterial(CurMaterial)
    render.DrawSprite(self:GetPos(), CurMaterial:Width(), CurMaterial:Height(), Color(255, 255, 255, 255)) 
end

function ENT:PhysicsCollide()
    self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	util.BlastDamage(self, self.Owner, self:GetPos(), 128, 128)
    self:EmitSound("DOOM64_RocketHit")
    self:SetNWString("CurSprite", "ent/rocket/MISLB0.png")
    timer.Simple(0.1, function()
        self:SetNWString("CurSprite", "ent/rocket/MISLC0.png")
    end)
    timer.Simple(0.2, function()
        self:SetNWString("CurSprite", "ent/rocket/MISLD0.png")
    end)
    timer.Simple(0.3, function()
        self:SetNWString("CurSprite", "ent/rocket/MISLE0.png")
    end)
    timer.Simple(0.4, function()
        self:SetNWString("CurSprite", "ent/rocket/MISLF0.png")
    end)
    timer.Simple(0.5, function()
        self:Remove()
    end)
end

function ENT:Touch(ent)
    if (ent != self.Owner) then
        self:PhysicsCollide() 
    end
end

scripted_ents.Register(ENT, "d64_rocketproj")