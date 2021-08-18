abstract type AbstractWatson <: AbstractFloat end

for DrWatsonN in (:DrWatson16, :DrWatson32, :DrWatson64)

@eval FloatN = $(Symbol("Float",string(DrWatsonN)[end-1:end]))

@eval begin

struct $DrWatsonN{f} <: AbstractWatson
    val::$FloatN
end

# conversions back from DrWatson64
Base.Float64(x::$DrWatsonN) = Float64(x.val)
Base.Float32(x::$DrWatsonN) = Float32(x.val)
Base.Float16(x::$DrWatsonN) = Float16(x.val)
Base.Int64(x::$DrWatsonN) = Int64(x.val)
Base.Int32(x::$DrWatsonN) = Int32(x.val)
Base.Int16(x::$DrWatsonN) = Int16(x.val)

# conversion among DrWatsons
$DrWatsonN{f}(x::$DrWatsonN) where f = $DrWatsonN{f}(x.val)
$DrWatsonN(x::$DrWatsonN{f}) where {f} = $DrWatsonN{f}(x.val)

Base.promote_rule(::Type{<:Integer},::Type{$DrWatsonN{f}}) where f = $DrWatsonN{f}
Base.promote_rule(::Type{Float64},::Type{$DrWatsonN{f}}) where f = $DrWatsonN{f}
Base.promote_rule(::Type{Float32},::Type{$DrWatsonN{f}}) where f = $DrWatsonN{f}
Base.promote_rule(::Type{Float16},::Type{$DrWatsonN{f}}) where f = $DrWatsonN{f}

Base.bitstring(x::$DrWatsonN) = bitstring(x.val)

Base.eps(::Type{$DrWatsonN{f}}) where f = eps(Float64)
Base.eps(x::$DrWatsonN) = eps(x.val)

Base.typemin(::$DrWatsonN{f}) where f = $DrWatsonN{f}(typemin($FloatN))
Base.typemax(::$DrWatsonN{f}) where f = $DrWatsonN{f}(typemax($FloatN))
Base.floatmin(::$DrWatsonN{f}) where f = $DrWatsonN{f}(floatmin($FloatN))
Base.floatmax(::$DrWatsonN{f}) where f = $DrWatsonN{f}(floatmax($FloatN))
Base.precision(::$DrWatsonN{f}) where f = $DrWatsonN{f}(precision($FloatN))

end

for O in (:(+), :(-), :(*), :(/), :(^))
    @eval function Base.$O(x::$DrWatsonN{f},y::$DrWatsonN{f}) where f
        r = $O(x.val, y.val)
        scent(f,r)
        return $DrWatsonN{f}(r)
    end
end

for O in (:(-), :(+),
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
        function Base.$O(x::$DrWatsonN{f}) where f
            r = $O(x.val)
            scent(f,r)
            return $DrWatsonN{f}(r)
        end
    end
end

for O in (:(<), :(<=))     # do not trigger scent for those
    @eval Base.$O(x::$DrWatsonN, y::$DrWatsonN) = $O(x.val, y.val)
end

@eval Random.rand(rng::Random.AbstractRNG, ::Random.Sampler{T}) where T<:$DrWatsonN = convert(T, rand(rng, $FloatN))
@eval Random.randn(rng::Random.AbstractRNG, ::Type{T}) where T<:$DrWatsonN = convert(T, randn(rng, $FloatN))
@eval Random.randexp(rng::Random.AbstractRNG, ::Type{T}) where T<:$DrWatsonN = convert(T, randexp(rng, $FloatN))

@eval round(::Type{T}, x::$DrWatsonN) where {T<:Integer} = round(T, x.val)
@eval rem(x::$DrWatsonN, y::$DrWatsonN) = Core.Intrinsics.rem_float(x.val, y.val)

end
