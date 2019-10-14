abstract type AbstractSherlog <: AbstractFloat end

struct Sherlog64{T<:AbstractFloat} <: AbstractSherlog    # T is the bitpattern type for logging
    val::Float64                                         # the value is always Float64
end

Base.UInt64(x::Sherlog64) = reinterpret(UInt64,x.val)
Base.Float64(x::Sherlog64) = x.val
Base.Float32(x::Sherlog64) = Float32(x.val)
Base.Float16(x::Sherlog64) = Float16(x.val)

Sherlog64(x::Float64) = Sherlog64{Float16}(x)
Sherlog64(x::Float32) = Sherlog64{Float16}(Float64(x))
Sherlog64(x::Float16) = Sherlog64{Float16}(Float64(x))

Sherlog64(x::Integer) = Sherlog64{Float16}(Float64(x))

Base.promote_rule(::Type{Int64},::Type{Sherlog64{T}}) where T = Sherlog64
Base.promote_rule(::Type{Int32},::Type{Sherlog64{T}}) where T = Sherlog64
Base.promote_rule(::Type{Int16},::Type{Sherlog64{T}}) where T = Sherlog64

Base.promote_rule(::Type{Float64},::Type{Sherlog64{T}}) where T = Sherlog64
Base.promote_rule(::Type{Float32},::Type{Sherlog64{T}}) where T = Sherlog64
Base.promote_rule(::Type{Float16},::Type{Sherlog64{T}}) where T = Sherlog64

bitstring(x::Sherlog64) = bitstring(x.val)
Base.show(io::IO,x::Sherlog64) = print(io,string(x.val))

function +(x::Sherlog64{T},y::Sherlog64{T}) where T
    r = x.val + y.val
    logit(T,r)
    return Sherlog64{T}(r)
end

function -(x::Sherlog64{T},y::Sherlog64{T}) where T
    r = x.val - y.val
    logit(T,r)
    return Sherlog64{T}(r)
end

function *(x::Sherlog64{T},y::Sherlog64{T}) where T
    r = x.val * y.val
    logit(T,r)
    return Sherlog64{T}(r)
end

function /(x::Sherlog64{T},y::Sherlog64{T}) where T
    r = x.val / y.val
    logit(T,r)
    return Sherlog64{T}(r)
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
        function Base.$O(x::Sherlog64{T}) where T
            r = $O(x.val)
            logit(T,r)
            return Sherlog64{T}(r)
        end
    end
end

for O in ( :(<), :(<=))
    @eval begin
        Base.$O(x::Sherlog64{T}, y::Sherlog64{T}) where T = $O(x.val, y.val)
    end
end
