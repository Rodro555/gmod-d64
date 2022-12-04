AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"

local SpriteTimer = 0
local IdleSprite = 0

function ENT:Initialize()
    self:SetNWString("CurSprite", "ent/bfgball/BFS1A0.png")
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
			self:GetPhysicsObject():SetVelocity(self:GetForward() * 1500)
		end

		if self:WaterLevel() > 0 then
			self:Remove()
		end
    end
 
    if CLIENT && CurTime() > SpriteTimer then
        if (self:GetSolid() != SOLID_NONE) then
            IdleSprite = not IdleSprite
            if (IdleSprite) then
                self:SetNWString("CurSprite", "ent/bfgball/BFS1B0.png")
            else
                self:SetNWString("CurSprite", "ent/bfgball/BFS1A0.png")
            end
            SpriteTimer = CurTime() + 0.05
        end
	end
    self:NextThink(CurTime() + 0.01)
	return true
end

function ENT:Draw()
    local CurMaterial = Material(self:GetNWString("CurSprite")) 
    render.SetMaterial(CurMaterial)
    render.DrawSprite(self:GetPos(), CurMaterial:Width(), CurMaterial:Height(), Color(255, 255, 255, 255)) 
end

function ENT:Touch(entity)
	if SERVER && entity != self.Owner then
		local dmg = DamageInfo()
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(math.random(100, 800))
		dmg:SetDamageType(DMG_PLASMA)
		dmg:SetDamageForce(self:GetForward())
		entity:TakeDamageInfo(dmg)
		self:PhysicsCollide()
	end
end

function ENT:FireTracers() 
    for i = -20, 20, 1 do 
        local TraceEnd = (self:GetPos() - self.Owner:GetShootPos()):GetNormalized() * 2048
        TraceEnd:Rotate(Angle(0, i * 2.25, 0))
        local tr = util.TraceLine({
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + TraceEnd,
            filter = self.Owner,
            mask = MASK_SHOT_HULL
        })

        if tr.Hit && (tr.Entity:IsNPC() || tr.Entity:IsPlayer()) then
            local dmg = DamageInfo()
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self)
            dmg:SetDamage(math.Rand(49, 87))
            dmg:SetDamageType(DMG_PLASMA)
            dmg:SetDamageForce(TraceEnd)
            tr.Entity:TakeDamageInfo(dmg)
            local ent = ents.Create("d64_bfgspark")
            ent:SetOwner(self.Owner)
            ent:SetPos(tr.HitPos)
            ent:SetAngles(Angle(0, 0, 0))
            ent:Spawn()
        end
    end
end

function ENT:PhysicsCollide()
    self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
    self:EmitSound("DOOM64_RocketHit")
    self:SetNWString("CurSprite", "ent/bfgball/BFS1C0.png")
    timer.Simple(0.1, function()
        self:SetNWString("CurSprite", "ent/bfgball/BFS1D0.png")
    end)
    timer.Simple(0.2, function()
        self:SetNWString("CurSprite", "ent/bfgball/BFS1E0.png")
        self:FireTracers()
    end)
    timer.Simple(0.3, function()
        self:SetNWString("CurSprite", "ent/bfgball/BFS1F0.png")
    end)
    timer.Simple(0.4, function()
        self:SetNWString("CurSprite", "ent/bfgball/BFS1G0.png")
    end)
    timer.Simple(0.5, function()
        self:SetNWString("CurSprite", "ent/bfgball/BFS1H0.png")
    end)
    timer.Simple(0.6, function()
        self:Remove()
    end)
end

scripted_ents.Register(ENT, "d64_bfgball")