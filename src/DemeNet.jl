module DemeNet

include("Types/Types.jl")
include("Plugins/Plugins.jl")
include("Keys/Keys.jl")
include("Demes/Demes.jl")
include("Profiles/Profiles.jl")
include("TOMLIO/TOMLIO.jl")
include("Crypto/Crypto.jl")


#function serialize end
#function deserialize end

import .Plugins: AbstractPlugin, Plugin, Notary, Cypher, CypherSuite
import .Keys: Signer, Certificate, Contract, Consensus, Intent, Envelope, verify
import .Types: ID, DemeID, AbstractID, datadir, keydir # keydir should be deprecated in the future
import .Demes: DemeSpec, Deme, save #, Signer
import .Profiles: Profile
import .TOMLIO: serialize, deserialize
import .Crypto: DHsym, DHasym


Plugin(::Type{T},deme::Deme) where T <: AbstractPlugin = Plugin[deme.spec.peacefounder](T,deme)
Plugin(::Type{T},deme::Deme,config) where T <: AbstractPlugin = Plugin[deme.spec.peacefounder](T,deme,config)

abstract type AbstractInitializer <: AbstractPlugin end
AbstractInitializer(deme) = Plugin(AbstractInitializer,deme)

### THE API of AbstractInitializer. Perhaps some kind of trait abstraction is needed ###
init(::AbstractInitializer,port::Dict) = error("Contract not satisfied") 
config(::AbstractInitializer) = error("Contract not satisfied") 
updateconfig(::AbstractInitializer) = error("Contract not satisfied") 

end
