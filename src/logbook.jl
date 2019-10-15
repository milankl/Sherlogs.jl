return_logbook() = logbook
reset_logbook() = set_logbook(zeros(UInt64,n16))

function set_logbook(x::Array{UInt64,1})
    if length(x) == n16
        logbook .= x
    else
        error("Array of length $(length(x)) instead of $n16.")
    end
    return nothing
end

"""Count arithmetic result in logbook."""
function logit(::Type{T},x::Float64) where {T<:AbstractFloat}
    logbook[reinterpret(UInt16,T(x)) + 1] += 1
end

"""Count arithmetic result in logbook."""
function logit(::Type{T},x::Float32) where {T<:AbstractFloat}
    logbook[reinterpret(UInt16,T(x)) + 1] += 1
end
