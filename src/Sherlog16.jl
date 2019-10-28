struct Sherlog16{T<:AbstractFloat} <: AbstractSherlog
    val::T
end

Base.UInt16(x::Sherlog16) = reinterpret(UInt16,x.val)
Base.Float64(x::Sherlog16) = Float64(x.val)
Base.Float32(x::Sherlog16) = Float32(x.val)
Base.Float16(x::Sherlog16) = Float16(x.val)

Sherlog16(x::T) where {T<:AbstractFloat} = Sherlog16{Float16}(x)
Sherlog16(x::Integer) = Sherlog16{Float16}(Float16(x))

Base.oneunit(::Type{Sherlog16{T}}) where {T<:AbstractFloat} = Sherlog16{T}(1)

Base.promote_rule(::Type{Int64},::Type{Sherlog16{T}}) where T = Sherlog16
Base.promote_rule(::Type{Int32},::Type{Sherlog16{T}}) where T = Sherlog16
Base.promote_rule(::Type{Int16},::Type{Sherlog16{T}}) where T = Sherlog16

Base.promote_rule(::Type{Float64},::Type{Sherlog16{T}}) where T = Sherlog16
Base.promote_rule(::Type{Float32},::Type{Sherlog16{T}}) where T = Sherlog16
Base.promote_rule(::Type{Float16},::Type{Sherlog16{T}}) where T = Sherlog16

bitstring(x::Sherlog16) = bitstring(x.val)
Base.show(io::IO,x::Sherlog16) = print(io,string(x.val))

Base.eps(::Type{Sherlog16{T}}) where {T<:AbstractFloat} = eps(T)

function +(x::Sherlog16{T},y::Sherlog16{T}) where T
    r = x.val + y.val
    logit(T,r)
    return Sherlog16{T}(r)
end

function -(x::Sherlog16{T},y::Sherlog16{T}) where T
    r = x.val - y.val
    logit(T,r)
    return Sherlog16{T}(r)
end

function *(x::Sherlog16{T},y::Sherlog16{T}) where T
    r = x.val * y.val
    logit(T,r)
    return Sherlog16{T}(r)
end

function /(x::Sherlog16{T},y::Sherlog16{T}) where T
    r = x.val / y.val
    logit(T,r)
    return Sherlog16{T}(r)
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
        function Base.$O(x::Sherlog16{T}) where T
            r = $O(x.val)
            logit(T,r)
            return Sherlog16{T}(r)
        end
    end
end

for O in ( :(<), :(<=))
    @eval begin
        Base.$O(x::Sherlog16{T}, y::Sherlog16{T}) where T = $O(x.val, y.val)
    end
end
