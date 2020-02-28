struct Sherlog32{T<:AbstractFloat,i} <: AbstractSherlog     # T is the bitpattern type for logging, i is the logbook #
    val::Float32                                            # the value is always Float32
end

# conversions back from Sherlog32
Base.Float64(x::Sherlog32) = Float64(x.val)
Base.Float32(x::Sherlog32) = x.val
Base.Float16(x::Sherlog32) = Float16(x.val)
Base.Int64(x::Sherlog32) = Int64(x.val)
Base.Int32(x::Sherlog32) = Int32(x.val)
Base.Int16(x::Sherlog32) = Int16(x.val)

# otherwise conversion to itself is ambigious
Sherlog32{T,i}(x::Sherlog32) where {T<:AbstractFloat,i} = Sherlog32{T,i}(x.val)
Sherlog32(x::Sherlog32{T,i}) where {T<:AbstractFloat,i} = Sherlog32{T,i}(x.val)

# generator functions from Float, Int and Bool
Sherlog32(x::AbstractFloat) = Sherlog32{Float16,1}(x)   # use Float16 and logbook #1 as standard
Sherlog32{T}(x::AbstractFloat) where T = Sherlog32{T,1}(x)      # use logbook #1 if no logbook provided
Sherlog32(x::Integer) = Sherlog32{Float16,1}(x)           # same for integers
Sherlog32{T}(x::Integer) where T = Sherlog32{T,1}(x)
Sherlog32{T}(x::Bool) where T = if x Sherlog32{T,1}(1) else Sherlog32{T,1}(0) end

Base.promote_rule(::Type{Int64},::Type{Sherlog32{T,i}}) where {T,i} = Sherlog32{T,i}
Base.promote_rule(::Type{Int32},::Type{Sherlog32{T,i}}) where {T,i} = Sherlog32{T,i}
Base.promote_rule(::Type{Int16},::Type{Sherlog32{T,i}}) where {T,i} = Sherlog32{T,i}

Base.promote_rule(::Type{Float64},::Type{Sherlog32{T,i}}) where {T,i} = Sherlog32{T,i}
Base.promote_rule(::Type{Float32},::Type{Sherlog32{T,i}}) where {T,i} = Sherlog32{T,i}
Base.promote_rule(::Type{Float16},::Type{Sherlog32{T,i}}) where {T,i} = Sherlog32{T,i}

Base.bitstring(x::Sherlog32) = bitstring(x.val)
Base.show(io::IO,x::Sherlog32) = print(io,"Sherlog32(",string(x.val),")")

Base.eps(::Type{Sherlog32}) = eps(Float64)
Base.eps(x::Sherlog32) = eps(x.val)

Base.typemin(::Sherlog32{T,i}) where {T,i} = Sherlog32{T,i}(typemin(Float32))
Base.typemax(::Sherlog32{T,i}) where {T,i} = Sherlog32{T,i}(typemax(Float32))
Base.floatmin(::Sherlog32{T,i}) where {T,i} = Sherlog32{T,i}(floatmin(Float32))
Base.floatmax(::Sherlog32{T,i}) where {T,i} = Sherlog32{T,i}(floatmax(Float32))
Base.precision(::Sherlog32{T,i}) where {T,i} = Sherlog32{T,i}(precision(Float32))

-(x::Sherlog32{T,i}) where {T,i} = Sherlog32{T,i}(-x.val)

function +(x::Sherlog32{T,i},y::Sherlog32{T,i}) where {T,i}
    r = x.val + y.val
    log_it(T,r,i)
    return Sherlog32{T,i}(r)
end

function -(x::Sherlog32{T,i},y::Sherlog32{T,i}) where {T,i}
    r = x.val - y.val
    log_it(T,r,i)
    return Sherlog32{T,i}(r)
end

function *(x::Sherlog32{T,i},y::Sherlog32{T,i}) where {T,i}
    r = x.val * y.val
    log_it(T,r,i)
    return Sherlog32{T,i}(r)
end

function /(x::Sherlog32{T,i},y::Sherlog32{T,i}) where {T,i}
    r = x.val / y.val
    log_it(T,r,i)
    return Sherlog32{T,i}(r)
end

function ^(x::Sherlog32{T,i},y::Sherlog32{T,i}) where {T,i}
    r = x.val ^ y.val
    log_it(T,r,i)
    return Sherlog32{T,i}(r)
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
        function Base.$O(x::Sherlog32{T,i}) where {T,i}
            r = $O(x.val)
            log_it(T,r,i)
            return Sherlog32{T,i}(r)
        end
    end
end

for O in ( :(<), :(<=))
    @eval begin
        Base.$O(x::Sherlog32, y::Sherlog32) = $O(x.val, y.val)
    end
end
