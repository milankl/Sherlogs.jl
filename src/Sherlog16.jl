struct Sherlog16{T<:AbstractFloat,i} <: AbstractSherlog     # T is the bitpattern type for logging, i is the logbook #
    val::T
end

# conversions back from Sherlog16
Base.Float64(x::Sherlog16) = Float64(x.val)
Base.Float32(x::Sherlog16) = Float32(x.val)
Base.Float16(x::Sherlog16) = Float16(x.val)
Base.Int64(x::Sherlog16) = Int64(x.val)
Base.Int32(x::Sherlog16) = Int32(x.val)
Base.Int16(x::Sherlog16) = Int16(x.val)

# otherwise conversion to itself is ambigious
Sherlog16{T,i}(x::Sherlog16) where {T<:AbstractFloat,i} = Sherlog16{T,i}(x.val)
Sherlog16(x::Sherlog16{T,i}) where {T<:AbstractFloat,i} = Sherlog16{T,i}(x.val)

# generator functions from Float, Int and Bool
Sherlog16(x::AbstractFloat) = Sherlog16{Float16,1}(x)   # use Float16 and logbook #1 as standard
Sherlog16{T}(x::AbstractFloat) where T = Sherlog16{T,1}(x)      # use logbook #1 if no logbook provided
Sherlog16(x::Integer) = Sherlog16{Float16,1}(x)           # same for integers
Sherlog16{T}(x::Integer) where T = Sherlog16{T,1}(x)
Sherlog16{T}(x::Bool) where T = if x Sherlog16{T,1}(1) else Sherlog16{T,1}(0) end

Base.promote_rule(::Type{Int64},::Type{Sherlog16{T,i}}) where {T,i} = Sherlog16{T,i}
Base.promote_rule(::Type{Int32},::Type{Sherlog16{T,i}}) where {T,i} = Sherlog16{T,i}
Base.promote_rule(::Type{Int16},::Type{Sherlog16{T,i}}) where {T,i} = Sherlog16{T,i}

Base.promote_rule(::Type{Float64},::Type{Sherlog16{T,i}}) where {T,i} = Sherlog16{T,i}
Base.promote_rule(::Type{Float32},::Type{Sherlog16{T,i}}) where {T,i} = Sherlog16{T,i}
Base.promote_rule(::Type{Float16},::Type{Sherlog16{T,i}}) where {T,i} = Sherlog16{T,i}

Base.bitstring(x::Sherlog16) = bitstring(x.val)
Base.show(io::IO,x::Sherlog16) = print(io,"Sherlog16(",string(x.val),")")

Base.eps(::Type{Sherlog16{T,i}}) where {T,i} = eps(Float64)
Base.eps(x::Sherlog16) = eps(x.val)

Base.typemin(::Sherlog16{T,i}) where {T,i} = Sherlog16{T,i}(typemin(T))
Base.typemax(::Sherlog16{T,i}) where {T,i} = Sherlog16{T,i}(typemax(T))
Base.floatmin(::Sherlog16{T,i}) where {T,i} = Sherlog16{T,i}(floatmin(T))
Base.floatmax(::Sherlog16{T,i}) where {T,i} = Sherlog16{T,i}(floatmax(T))
Base.precision(::Sherlog16{T,i}) where {T,i} = Sherlog16{T,i}(precision(T))

function +(x::Sherlog16{T,i},y::Sherlog16{T,i}) where {T,i}
    r = x.val + y.val
    log_it(T,r,i)
    return Sherlog16{T,i}(r)
end

function -(x::Sherlog16{T,i},y::Sherlog16{T,i}) where {T,i}
    r = x.val - y.val
    log_it(T,r,i)
    return Sherlog16{T,i}(r)
end

function *(x::Sherlog16{T,i},y::Sherlog16{T,i}) where {T,i}
    r = x.val * y.val
    log_it(T,r,i)
    return Sherlog16{T,i}(r)
end

function /(x::Sherlog16{T,i},y::Sherlog16{T,i}) where {T,i}
    r = x.val / y.val
    log_it(T,r,i)
    return Sherlog16{T,i}(r)
end

function ^(x::Sherlog16{T,i},y::Sherlog16{T,i}) where {T,i}
    r = x.val ^ y.val
    log_it(T,r,i)
    return Sherlog16{T,i}(r)
end

for O in ( :(-), :(+),
           :sign,
           :prevfloat, :nextfloat,
           :round, :trunc, :ceil, :floor,
           :inv, :abs, :sqrt, :cbrt,
           :exp, :expm1, :exp2, :exp10,
           :log, :log1p, :log2, :log10,
           :rad2deg, :deg2rad, :mod2pi, :rem2pi,
           :sin, :cos, :tan, :csc, :sec, :cot,
           :asin, :acos, :atan, :acsc, :asec, :acot,
           :sinh, :cosh, :tanh, :csch, :sech, :coth,
           :asinh, :acosh, :atanh, :acsch, :asech, :acoth,
           :sinc, :sinpi, :cospi,
           :sind, :cosd, :tand, :cscd, :secd, :cotd,
           :asind, :acosd, :atand, :acscd, :asecd, :acotd
          )
    @eval begin
        function Base.$O(x::Sherlog16{T,i}) where {T,i}
            r = $O(x.val)
            log_it(T,r,i)
            return Sherlog16{T,i}(r)
        end
    end
end

for O in ( :(<), :(<=))
    @eval begin
        Base.$O(x::Sherlog16, y::Sherlog16) = $O(x.val, y.val)
    end
end
