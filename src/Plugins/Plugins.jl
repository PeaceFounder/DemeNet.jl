module Plugins

using ..Types: uuid

abstract type AbstractPlugin end

abstract type AbstractInitializer <: AbstractPlugin end

function init end
#init(::AbstractInitializer,deme::Deme,config::Dict) = error("Impl. error")

# Loads a configuration file for the particular peacefounder
#config(::AbstractInitializer,deme::Deme) = error("Impl. error")
function config end

# updates the PeaceFounder.toml file using information in existing one
#update(::AbstractInitializer,deme::Deme) = error("Impl. error")
function updateconfig end


using Base: UUID

struct Notary
    Signer::Function # allows to create signatures when necessery. id is obtained with verify on random data.
    Signature::Function 
    verify::Function # verify returns id of the signature.
    hash::Function
end

struct Cypher
    G # a group for DiffieHellman key exchange
    rng::Function
    secureio::Function 
end

struct CypherSuite{T} end ### This type belongs to plugins
CypherSuite(uuid::UUID) = CypherSuite{uuid.value}
CypherSuite(m::Module) = CypherSuite(uuid(m))

Notary(cyphersuite::UUID,crypto::Symbol) = Notary(CypherSuite(cyphersuite),crypto)::Notary
Cypher(cyphersuite::UUID,crypto::Symbol) = Cypher(CypherSuite(cyphersuite),crypto)::Cypher

using Pkg.Types: Context

struct Plugin{T} end
#Plugin(uuid::UUID) = Plugin{uuid.value}

import Base.getindex

getindex(::Type{Plugin},uuid::UUID) = Plugin{uuid.value}
function getindex(::Type{Plugin},x::Module) 
    ctx = Context()
    name = nameof(x)
    uuid = ctx.env.project.deps[name]
    return Plugin[uuid]
end

Plugin(::Type{T}) where T <: AbstractPlugin = error("Plugin is not installed for this Deme")

export Notary, Cypher, CypherSuite, Plugin

end
