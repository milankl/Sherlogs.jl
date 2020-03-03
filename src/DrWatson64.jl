abstract type AbstractWatson <: AbstractFloat end

struct DrWatson64{f} <: AbstractWatson
    val::Float64
end

# conversions back from Sherlog64
Base.Float64(x::DrWatson64) = x.val
Base.Float32(x::DrWatson64) = Float32(x.val)
Base.Float16(x::DrWatson64) = Float16(x.val)
Base.Int64(x::DrWatson64) = Int64(x.val)
Base.Int32(x::DrWatson64) = Int32(x.val)
Base.Int16(x::DrWatson64) = Int16(x.val)

# conversion among DrWatsons
DrWatson64{f}(x::DrWatson64) where f = DrWatson64{f}(x.val)
DrWatson64(x::DrWatson64{f}) where {f} = DrWatson64{f}(x.val)

Base.promote_rule(::Type{Int64},::Type{DrWatson64{f}}) where f = DrWatson64{f}
Base.promote_rule(::Type{Int32},::Type{DrWatson64{f}}) where f = DrWatson64{f}
Base.promote_rule(::Type{Int16},::Type{DrWatson64{f}}) where f = DrWatson64{f}

Base.promote_rule(::Type{Float64},::Type{DrWatson64{f}}) where f = DrWatson64{f}
Base.promote_rule(::Type{Float32},::Type{DrWatson64{f}}) where f = DrWatson64{f}
Base.promote_rule(::Type{Float16},::Type{DrWatson64{f}}) where f = DrWatson64{f}

Base.bitstring(x::DrWatson64) = bitstring(x.val)

Base.eps(::Type{DrWatson64{f}}) where f = eps(Float64)
Base.eps(x::DrWatson64) = eps(x.val)

Base.typemin(::DrWatson64{f}) where f = DrWatson64{f}(typemin(Float64))
Base.typemax(::DrWatson64{f}) where f = DrWatson64{f}(typemax(Float64))
Base.floatmin(::DrWatson64{f}) where f = DrWatson64{f}(floatmin(Float64))
Base.floatmax(::DrWatson64{f}) where f = DrWatson64{f}(floatmax(Float64))
Base.precision(::DrWatson64{f}) where f = DrWatson64{f}(precision(Float64))

function +(x::DrWatson64{f},y::DrWatson64{f}) where f
    r = x.val + y.val
    scent(f,r)
    return DrWatson64{f}(r)
end

function -(x::DrWatson64{f},y::DrWatson64{f}) where f
    r = x.val - y.val
    scent(f,r)
    return DrWatson64{f}(r)
end

function *(x::DrWatson64{f},y::DrWatson64{f}) where f
    r = x.val * y.val
    scent(f,r)
    return DrWatson64{f}(r)
end

function /(x::DrWatson64{f},y::DrWatson64{f}) where f
    r = x.val / y.val
    scent(f,r)
    return DrWatson64{f}(r)
end

function ^(x::DrWatson64{f},y::DrWatson64{f}) where f
    r = x.val ^ y.val
    scent(f,r)
    return DrWatson64{f}(r)
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
        function Base.$O(x::DrWatson64{f}) where f
            r = $O(x.val)
            scent(f,r)
            return DrWatson64{f}(r)
        end
    end
end

for O in ( :(<), :(<=))     # do not trigger scent for those
    @eval begin
        Base.$O(x::DrWatson64, y::DrWatson64) = $O(x.val, y.val)
    end
end
