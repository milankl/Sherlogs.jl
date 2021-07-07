struct DrWatson32{f} <: AbstractWatson
    val::Float32
end

# conversions back from DrWatsons
Base.Float64(x::DrWatson32) = Float64(x.val)
Base.Float32(x::DrWatson32) = x.val
Base.Float16(x::DrWatson32) = Float16(x.val)
Base.Int64(x::DrWatson32) = Int64(x.val)
Base.Int32(x::DrWatson32) = Int32(x.val)
Base.Int16(x::DrWatson32) = Int16(x.val)

# conversion among DrWatsons
DrWatson32{f}(x::DrWatson32) where f = DrWatson32{f}(x.val)
DrWatson32(x::DrWatson32{f}) where {f} = DrWatson32{f}(x.val)

Base.promote_rule(::Type{Int64},::Type{DrWatson32{f}}) where f = DrWatson32{f}
Base.promote_rule(::Type{Int32},::Type{DrWatson32{f}}) where f = DrWatson32{f}
Base.promote_rule(::Type{Int16},::Type{DrWatson32{f}}) where f = DrWatson32{f}

Base.promote_rule(::Type{Float64},::Type{DrWatson32{f}}) where f = DrWatson32{f}
Base.promote_rule(::Type{Float32},::Type{DrWatson32{f}}) where f = DrWatson32{f}
Base.promote_rule(::Type{Float16},::Type{DrWatson32{f}}) where f = DrWatson32{f}

Base.bitstring(x::DrWatson32) = bitstring(x.val)

Base.eps(::Type{DrWatson32{f}}) where f = eps(Float32)
Base.eps(x::DrWatson32) = eps(x.val)

Base.typemin(::DrWatson32{f}) where f = DrWatson32{f}(typemin(Float32))
Base.typemax(::DrWatson32{f}) where f = DrWatson32{f}(typemax(Float32))
Base.floatmin(::DrWatson32{f}) where f = DrWatson32{f}(floatmin(Float32))
Base.floatmax(::DrWatson32{f}) where f = DrWatson32{f}(floatmax(Float32))
Base.precision(::DrWatson32{f}) where f = DrWatson32{f}(precision(Float32))

function +(x::DrWatson32{f},y::DrWatson32{f}) where f
    r = x.val + y.val
    scent(f,r)
    return DrWatson32{f}(r)
end

function -(x::DrWatson32{f},y::DrWatson32{f}) where f
    r = x.val - y.val
    scent(f,r)
    return DrWatson32{f}(r)
end

function *(x::DrWatson32{f},y::DrWatson32{f}) where f
    r = x.val * y.val
    scent(f,r)
    return DrWatson32{f}(r)
end

function /(x::DrWatson32{f},y::DrWatson32{f}) where f
    r = x.val / y.val
    scent(f,r)
    return DrWatson32{f}(r)
end

function ^(x::DrWatson32{f},y::DrWatson32{f}) where f
    r = x.val ^ y.val
    scent(f,r)
    return DrWatson32{f}(r)
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
        function Base.$O(x::DrWatson32{f}) where f
            r = $O(x.val)
            scent(f,r)
            return DrWatson32{f}(r)
        end
    end
end

for O in ( :(<), :(<=))     # do not trigger scent for those
    @eval begin
        Base.$O(x::DrWatson32, y::DrWatson32) = $O(x.val, y.val)
    end
end
