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
function logit(::Type{T},x::AbstractFloat) where {T<:AbstractFloat}

    if x > 1000.0
        SA[:,idx[1]] = stacktrace()[1:stmax]
        idx[1] = mod(idx[1]+1,idxmax)
    end

    logbook[reinterpret(UInt16,T(x)) + 1] += 1
end
