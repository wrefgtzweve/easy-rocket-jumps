-- Convars
local enabled = CreateConVar( "rocketjumps_enabled", 1, { FCVAR_ARCHIVE }, "The damage multiplier for self damaging explosions.", 0 ):GetInt()
cvars.AddChangeCallback( "rocketjumps_enabled", function( _, _, val )
    enabled = tonumber( val )
end)

local scaleDamage = CreateConVar( "rocketjumps_dmgmult", 0.4, { FCVAR_ARCHIVE }, "The damage multiplier for self damaging explosions.", 0 ):GetFloat()
cvars.AddChangeCallback( "rocketjumps_dmgmult", function( _, _, val )
    scaleDamage = tonumber( val )
end)

local forceMult = CreateConVar( "rocketjumps_forcemult", 1, { FCVAR_ARCHIVE }, "The force multiplier for self damaging explosions.", 0 ):GetFloat()
cvars.AddChangeCallback( "rocketjumps_forcemult", function( _, _, val )
    forceMult = tonumber( val )
end)

local function reduceRocketDamage( ent, dmginfo )
    if not enabled then return end
    if not dmginfo:IsExplosionDamage() then return end
    if not ent:IsPlayer() then return end

    local attacker = dmginfo:GetAttacker()

    if attacker ~= ent then return end

    local dmgForce = dmginfo:GetDamageForce()
    local newForce = dmgForce * forceMult
    dmginfo:SetDamageForce( newForce )

    if ent:KeyDown( IN_DUCK	) then
        ent:SetVelocity( newForce / 35 )
    else
        ent:SetVelocity( newForce / 70 )
    end

    dmginfo:ScaleDamage( scaleDamage )
end

hook.Add( "EntityTakeDamage", "rocketjumpsEntityTakeDamage", reduceRocketDamage )
