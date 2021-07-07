struct DrWatson16{f} <: AbstractWatson
    val::Float16
end

# conversions back from DrWatsons
Base.Float64(x::DrWatson16) = Float64(x.val)
Base.Float32(x::DrWatson16) = Float32(x.val)
Base.Float16(x::DrWatson16) = x.val
Base.Int64(x::DrWatson16) = Int64(x.val)
Base.Int32(x::DrWatson16) = Int32(x.val)
Base.Int16(x::DrWatson16) = Int16(x.val)

# conversion among DrWatsons
DrWatson16{f}(x::DrWatson16) where f = DrWatson16{f}(x.val)
DrWatson16(x::DrWatson16{f}) where {f} = DrWatson16{f}(x.val)

Base.promote_rule(::Type{Int64},::Type{DrWatson16{f}}) where f = DrWatson16{f}
Base.promote_rule(::Type{Int32},::Type{DrWatson16{f}}) where f = DrWatson16{f}
Base.promote_rule(::Type{Int16},::Type{DrWatson16{f}}) where f = DrWatson16{f}

Base.promote_rule(::Type{Float64},::Type{DrWatson16{f}}) where f = DrWatson16{f}
Base.promote_rule(::Type{Float32},::Type{DrWatson16{f}}) where f = DrWatson16{f}
Base.promote_rule(::Type{Float16},::Type{DrWatson16{f}}) where f = DrWatson16{f}

Base.bitstring(x::DrWatson16) = bitstring(x.val)

Base.eps(::Type{DrWatson16{f}}) where f = eps(Float16)
Base.eps(x::DrWatson16) = eps(x.val)

Base.typemin(::DrWatson16{f}) where f = DrWatson16{f}(typemin(Float16))
Base.typemax(::DrWatson16{f}) where f = DrWatson16{f}(typemax(Float16))
Base.floatmin(::DrWatson16{f}) where f = DrWatson16{f}(floatmin(Float16))
Base.floatmax(::DrWatson16{f}) where f = DrWatson16{f}(floatmax(Float16))
Base.precision(::DrWatson16{f}) where f = DrWatson16{f}(precision(Float16))

function +(x::DrWatson16{f},y::DrWatson16{f}) where f
    r = x.val + y.val
    scent(f,r)
    return DrWatson16{f}(r)
end

function -(x::DrWatson16{f},y::DrWatson16{f}) where f
    r = x.val - y.val
    scent(f,r)
    return DrWatson16{f}(r)
end

function *(x::DrWatson16{f},y::DrWatson16{f}) where f
    r = x.val * y.val
    scent(f,r)
    return DrWatson16{f}(r)
end

function /(x::DrWatson16{f},y::DrWatson16{f}) where f
    r = x.val / y.val
    scent(f,r)
    return DrWatson16{f}(r)
end

function ^(x::DrWatson16{f},y::DrWatson16{f}) where f
    r = x.val ^ y.val
    scent(f,r)
    return DrWatson16{f}(r)
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
        function Base.$O(x::DrWatson16{f}) where f
            r = $O(x.val)
            scent(f,r)
            return DrWatson16{f}(r)
        end
    end
end

for O in ( :(<), :(<=))     # do not trigger scent for those
    @eval begin
        Base.$O(x::DrWatson16, y::DrWatson16) = $O(x.val, y.val)
    end
end
