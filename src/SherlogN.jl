abstract type AbstractSherlog <: AbstractFloat end

for SherlogN in (:Sherlog16, :Sherlog32, :Sherlog64)

@eval Float = $(Symbol("Float",string(SherlogN)[end-1:end]))

@eval begin

struct $SherlogN{T<:AbstractFloat,i} <: AbstractSherlog    # T is the bitpattern type for logging, i the logbook id
    val::$Float
end

# conversions back from Sherlog
Base.Float64(x::$SherlogN) = Float64(x.val)
Base.Float32(x::$SherlogN) = Float32(x.val)
Base.Float16(x::$SherlogN) = Float16(x.val)
Base.Int64(x::$SherlogN) = Int64(x.val)
Base.Int32(x::$SherlogN) = Int32(x.val)
Base.Int16(x::$SherlogN) = Int16(x.val)

# otherwise conversion to itself is ambigious
$SherlogN{T,i}(x::$SherlogN) where {T<:AbstractFloat,i} = $SherlogN{T,i}(x.val)
$SherlogN(x::$SherlogN{T,i}) where {T<:AbstractFloat,i} = $SherlogN{T,i}(x.val)

# generator functions from Float, Int and Bool
$SherlogN(x::AbstractFloat) = $SherlogN{Float16,1}(x)   # use Float16 and logbook #1 as standard
$SherlogN{T}(x::AbstractFloat) where T = $SherlogN{T,1}(x)      # use logbook #1 if no logbook provided
$SherlogN(x::Integer) = $SherlogN{Float16,1}(x)           # same for integers
$SherlogN{T}(x::Integer) where T = $SherlogN{T,1}(x)
$SherlogN{T}(x::Bool) where T = if x $SherlogN{T,1}(1) else $SherlogN{T,1}(0) end

Base.promote_rule(::Type{<:Integer},::Type{$SherlogN{T,i}}) where {T,i} = $SherlogN{T,i}
Base.promote_rule(::Type{Float64},::Type{$SherlogN{T,i}}) where {T,i} = $SherlogN{T,i}
Base.promote_rule(::Type{Float32},::Type{$SherlogN{T,i}}) where {T,i} = $SherlogN{T,i}
Base.promote_rule(::Type{Float16},::Type{$SherlogN{T,i}}) where {T,i} = $SherlogN{T,i}

Base.bitstring(x::$SherlogN) = bitstring(x.val)
Base.show(io::IO,x::$SherlogN) = print(io,$SherlogN,"(",string(x.val),")")

Base.eps(::Type{$SherlogN{T,i}}) where {T,i} = eps(Float64)
Base.eps(x::$SherlogN) = eps(x.val)

Base.typemin(::$SherlogN{T,i}) where {T,i} = $SherlogN{T,i}(typemin($Float))
Base.typemax(::$SherlogN{T,i}) where {T,i} = $SherlogN{T,i}(typemax($Float))
Base.floatmin(::$SherlogN{T,i}) where {T,i} = $SherlogN{T,i}(floatmin($Float))
Base.floatmax(::$SherlogN{T,i}) where {T,i} = $SherlogN{T,i}(floatmax($Float))
Base.precision(::$SherlogN{T,i}) where {T,i} = $SherlogN{T,i}(precision($Float))

end

for O in (:(+), :(-), :(*), :(/), :(^))
    @eval function Base.$O(x::$SherlogN{T,i},y::$SherlogN{T,i}) where {T,i}
        r = $O(x.val, y.val)
        log_it(T,r,i)
        return $SherlogN{T,i}(r)
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
    @eval function Base.$O(x::$SherlogN{T,i}) where {T,i}
        r = $O(x.val)
        log_it(T,r,i)
        return $SherlogN{T,i}(r)
    end
end

for O in (:(<), :(<=))
    @eval Base.$O(x::$SherlogN, y::$SherlogN) = $O(x.val, y.val)
end

@eval Random.rand(rng::Random.AbstractRNG, ::Random.Sampler{$SherlogN}) = convert($SherlogN,rand(rng, $Float))
@eval Random.randn(rng::Random.AbstractRNG, ::Random.Sampler{$SherlogN}) = convert($SherlogN,randn(rng, $Float))

@eval round(::Type{T}, x::$SherlogN) where {T<:Integer} = round(T, x.val)
@eval rem(x::$SherlogN, y::$SherlogN) = Core.Intrinsics.rem_float(x.val, y.val)

end
