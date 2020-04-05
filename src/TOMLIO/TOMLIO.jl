module TOMLIO

using Pkg.TOML

function stack(io::IO,msg::Vector{UInt8})
    frontbytes = reinterpret(UInt8,Int16[length(msg)])
    item = UInt8[frontbytes...,msg...]
    write(io,item)
end

function unstack(io::IO)
    sizebytes = [read(io,UInt8),read(io,UInt8)]
    size = reinterpret(Int16,sizebytes)[1]
    
    msg = UInt8[]
    for i in 1:size
        push!(msg,read(io,UInt8))
    end
    return msg
end

import Base: GenericIOBuffer

function serialize(io::GenericIOBuffer,x::Any) #:Certificate{MemberID}) 
    dict = Dict(x)
    TOML.print(io, dict)
end

function deserialize(io::GenericIOBuffer,::Type{T}) where T
    str = String(take!(io))
    dict = TOML.parse(str)
    #return Certificate{MemberID}(dict)
    return T(dict)
end

function serialize(io::IO,x::Any)
    msg = IOBuffer()
    serialize(msg,x)
    stack(io,take!(msg))
end

function deserialize(io::IO,x::Type{T}) where T
    msg = unstack(io)
    return deserialize(IOBuffer(msg),x)
end

export serialize, deserialize

end
