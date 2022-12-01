AddCSLuaFile()

ENT.Spawnable = false

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
    self:SetNWString("CurSprite", "ent/unmakerlsr/LASSA0.png")
    timer.Simple(0.1, function()
        self:SetNWString("CurSprite", "ent/unmakerlsr/LASSB0.png")
    end)
    timer.Simple(0.3, function()
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

scripted_ents.Register(ENT, "d64_unmakerspark")