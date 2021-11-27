-- Convars
local enabled = CreateConVar( "rocketjumps_enabled", 1, { FCVAR_ARCHIVE }, "Enables rocket jumping (1/0).", 0 )
local scaleDamage = CreateConVar( "rocketjumps_dmgmult", 0.4, { FCVAR_ARCHIVE }, "The damage multiplier for self damaging explosions.", 0 )
local forceMult = CreateConVar( "rocketjumps_forcemult", 1, { FCVAR_ARCHIVE }, "The force multiplier for self damaging explosions.", 0 )
local allExplosions = CreateConVar( "rocketjumps_allexplosions", 0, { FCVAR_ARCHIVE }, "Should the force multiplier be applied to all explosions instead of only self inflicted ones?.", 0 )

local function reduceRocketDamage( ent, dmginfo )
    if not enabled:GetBool() then return end
    if not dmginfo:IsExplosionDamage() then return end
    if not ent:IsPlayer() then return end

    local attacker = dmginfo:GetAttacker()

    if not allExplosions:GetBool() and attacker ~= ent then return end

    local dmgForce = dmginfo:GetDamageForce()
    local newForce = dmgForce * forceMult:GetFloat()
    dmginfo:SetDamageForce( newForce )

    if ent:KeyDown( IN_DUCK ) then
        ent:SetVelocity( newForce / 35 )
    else
        ent:SetVelocity( newForce / 70 )
    end

    dmginfo:ScaleDamage( scaleDamage:GetFloat() )
end

hook.Add( "EntityTakeDamage", "rocketjumpsEntityTakeDamage", reduceRocketDamage )
