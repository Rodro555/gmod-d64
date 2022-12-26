function EFFECT:Init(data)
	local emitter = ParticleEmitter(data:GetOrigin())
	local smoke = emitter:Add("ent/rocket/puff", data:GetOrigin())
	smoke:SetDieTime(0.1)
	smoke:SetStartAlpha(20)
	smoke:SetEndAlpha(20)
	smoke:SetStartSize(10)
	smoke:SetEndSize(10)
	smoke:SetColor(255, 255, 255, 100)
	smoke:SetVelocity(Vector(0, 0, 50))
end

function EFFECT:Render()
end