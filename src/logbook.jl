struct LogBook
    logbook::Array{UInt64,1}
end

const n16 = 2^16
const nlogbooks = 32
const logbooks = [LogBook(zeros(UInt64,n16)) for _ in 1:nlogbooks]

"""Change the histogram array of logbook #id with UInt64 array x."""
function set_logbook(x::Array{UInt64,1},id::Int)
    if length(x) == n16
        logbooks[id].logbook .= x
    else
        error("Array of length $(length(x)) instead of $n16.")
    end
    return nothing
end

"""Change the type T of logbook #id. Must be a 16bit type."""
function set_logbook(T::DataType,id::Int=1)
    if sizeof(T) == 2   # must be a 16bit type
        logbook_types[id] = T
    else
        error("$(sizeof(T)*8)bit type $T was provided but must be a 16bit type.")
    end
    return nothing
end

get_logbooks() = logbooks
get_logbook(id::Int=1) = logbooks[id]
reset_logbook(id::Int=1) = set_logbook(zeros(UInt64,n16),id)
reset_logbooks() = for id in 1:nlogbooks reset_logbook(id) end
set_logbooks(T::DataType) = for id in 1:nlogbooks set_logbook(T,id) end

"""Count arithmetic result in logbook."""
function log_it(::Type{T},x::AbstractFloat,id::Int) where {T<:AbstractFloat}
    logbooks[id].logbook[reinterpret(UInt16,T(x)) + 1] += 1
end

Base.sum(x::LogBook)::Int64 = sum(x.logbook)
entropy(x::LogBook,b::Real) = entropy(x.logbook/sum(x),b)
entropy(x::LogBook) = entropy(x.logbook/sum(x))

function Base.show(io::IO,x::LogBook)
    if length(x.logbook) > 10
        print(io,"LogBook(")
        [print(io,string(Int(i)),", ") for i in x.logbook[1:5]]
        print(io,"… , ")
        [print(io,string(Int(i)),", ") for i in x.logbook[end-5:end-1]]
        print(io,string(Int(x.logbook[end])),")")
    else
        print(io,"LogBook(")
        [print(io,string(Int(i)),", ") for i in x.logbook[1:end-1]]
        print(io,string(Int(x.logbook[end])),")")
    end
end
