AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self:SetNWString("CurSprite", "ent/plsball/PLSSA0.png")
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
	end
	self:NextThink(0.01)
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
    self:EmitSound("DOOM64_RocketHit")
    self:SetNWString("CurSprite", "ent/plsball/PLSSC0.png")
    timer.Simple(0.1, function()
        self:SetNWString("CurSprite", "ent/plsball/PLSSD0.png")
    end)
    timer.Simple(0.2, function()
        self:SetNWString("CurSprite", "ent/plsball/PLSSE0.png")
    end)
    timer.Simple(0.3, function()
        self:SetNWString("CurSprite", "ent/plsball/PLSSF0.png")
    end)
    timer.Simple(0.4, function()
        self:SetNWString("CurSprite", "ent/plsball/PLSSG0.png")
    end)
    timer.Simple(0.5, function()
        self:SetNWString("CurSprite", "ent/plsball/PLSSH0.png")
    end)
    timer.Simple(0.6, function()
        self:Remove()
    end)
end

function ENT:Touch(entity)
	if SERVER && entity != self.Owner then
		local dmg = DamageInfo()
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(math.random(5, 40))
		dmg:SetDamageType(DMG_PLASMA)
		dmg:SetDamageForce(self:GetForward())
		entity:TakeDamageInfo(dmg)
		self:PhysicsCollide()
	end
end

scripted_ents.Register(ENT, "d64_plasmaball")