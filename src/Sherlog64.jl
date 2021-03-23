abstract type AbstractSherlog <: AbstractFloat end

struct Sherlog64{T<:AbstractFloat,i} <: AbstractSherlog    # T is the bitpattern type for logging
    val::Float64                                         # the value is always Float64
end

# conversions back from Sherlog64
Base.Float64(x::Sherlog64) = x.val
Base.Float32(x::Sherlog64) = Float32(x.val)
Base.Float16(x::Sherlog64) = Float16(x.val)
Base.Int64(x::Sherlog64) = Int64(x.val)
Base.Int32(x::Sherlog64) = Int32(x.val)
Base.Int16(x::Sherlog64) = Int16(x.val)

# otherwise conversion to itself is ambigious
Sherlog64{T,i}(x::Sherlog64) where {T<:AbstractFloat,i} = Sherlog64{T,i}(x.val)
Sherlog64(x::Sherlog64{T,i}) where {T<:AbstractFloat,i} = Sherlog64{T,i}(x.val)

# generator functions from Float, Int and Bool
Sherlog64(x::AbstractFloat) = Sherlog64{Float16,1}(x)   # use Float16 and logbook #1 as standard
Sherlog64{T}(x::AbstractFloat) where T = Sherlog64{T,1}(x)      # use logbook #1 if no logbook provided
Sherlog64(x::Integer) = Sherlog64{Float16,1}(x)           # same for integers
Sherlog64{T}(x::Integer) where T = Sherlog64{T,1}(x)
Sherlog64{T}(x::Bool) where T = if x Sherlog64{T,1}(1) else Sherlog64{T,1}(0) end

Base.promote_rule(::Type{Int64},::Type{Sherlog64{T,i}}) where {T,i} = Sherlog64{T,i}
Base.promote_rule(::Type{Int32},::Type{Sherlog64{T,i}}) where {T,i} = Sherlog64{T,i}
Base.promote_rule(::Type{Int16},::Type{Sherlog64{T,i}}) where {T,i} = Sherlog64{T,i}

Base.promote_rule(::Type{Float64},::Type{Sherlog64{T,i}}) where {T,i} = Sherlog64{T,i}
Base.promote_rule(::Type{Float32},::Type{Sherlog64{T,i}}) where {T,i} = Sherlog64{T,i}
Base.promote_rule(::Type{Float16},::Type{Sherlog64{T,i}}) where {T,i} = Sherlog64{T,i}

Base.bitstring(x::Sherlog64) = bitstring(x.val)
Base.show(io::IO,x::Sherlog64) = print(io,"Sherlog64(",string(x.val),")")

Base.eps(::Type{Sherlog64{T,i}}) where {T,i} = eps(Float64)
Base.eps(x::Sherlog64) = eps(x.val)

Base.typemin(::Sherlog64{T,i}) where {T,i} = Sherlog64{T,i}(typemin(Float64))
Base.typemax(::Sherlog64{T,i}) where {T,i} = Sherlog64{T,i}(typemax(Float64))
Base.floatmin(::Sherlog64{T,i}) where {T,i} = Sherlog64{T,i}(floatmin(Float64))
Base.floatmax(::Sherlog64{T,i}) where {T,i} = Sherlog64{T,i}(floatmax(Float64))
Base.precision(::Sherlog64{T,i}) where {T,i} = Sherlog64{T,i}(precision(Float64))

function +(x::Sherlog64{T,i},y::Sherlog64{T,i}) where {T,i}
    r = x.val + y.val
    log_it(T,r,i)
    return Sherlog64{T,i}(r)
end

function -(x::Sherlog64{T,i},y::Sherlog64{T,i}) where {T,i}
    r = x.val - y.val
    log_it(T,r,i)
    return Sherlog64{T,i}(r)
end

function *(x::Sherlog64{T,i},y::Sherlog64{T,i}) where {T,i}
    r = x.val * y.val
    log_it(T,r,i)
    return Sherlog64{T,i}(r)
end

function /(x::Sherlog64{T,i},y::Sherlog64{T,i}) where {T,i}
    r = x.val / y.val
    log_it(T,r,i)
    return Sherlog64{T,i}(r)
end

function ^(x::Sherlog64{T,i},y::Sherlog64{T,i}) where {T,i}
    r = x.val ^ y.val
    log_it(T,r,i)
    return Sherlog64{T,i}(r)
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
        function Base.$O(x::Sherlog64{T,i}) where {T,i}
            r = $O(x.val)
            log_it(T,r,i)
            return Sherlog64{T,i}(r)
        end
    end
end

for O in ( :(<), :(<=))
    @eval begin
        Base.$O(x::Sherlog64, y::Sherlog64) = $O(x.val, y.val)
    end
end
