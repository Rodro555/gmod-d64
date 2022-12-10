AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self:SetNWString("CurSprite", "ent/bfgspark/BFE2A0.png")
    timer.Simple(0.1, function()
        self:SetNWString("CurSprite", "ent/bfgspark/BFE2B0.png")
    end)
    timer.Simple(0.2, function()
        self:SetNWString("CurSprite", "ent/bfgspark/BFE2C0.png")
    end)
    timer.Simple(0.3, function()
        self:SetNWString("CurSprite", "ent/bfgspark/BFE2D0.png")
    end)
    timer.Simple(0.4, function()
        self:SetNWString("CurSprite", "ent/bfgspark/BFE2E0.png")
    end)
    timer.Simple(0.5, function()
        self:SetNWString("CurSprite", "ent/bfgspark/BFE2F0.png")
    end)
    timer.Simple(0.6, function()
        if SERVER then
            self:Remove() 
        end
    end)
end

function ENT:Draw()
    local CurMaterial = Material(self:GetNWString("CurSprite")) 
    render.SetMaterial(CurMaterial)
    render.DrawSprite(self:GetPos(), CurMaterial:Width(), CurMaterial:Height(), Color(255, 255, 255, 255)) 
end

scripted_ents.Register(ENT, "d64_bfgspark")