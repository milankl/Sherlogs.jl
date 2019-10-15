[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.com/milankl/Sherlogs.jl.svg?branch=master)](https://travis-ci.com/milankl/Sherlogs.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/milankl/Sherlogs.jl?svg=true)](https://ci.appveyor.com/project/milankl/Sherlogs-jl)
[![Build Status](https://api.cirrus-ci.com/github/milankl/Sherlogs.jl.svg)](https://cirrus-ci.com/github/milankl/Sherlogs.jl)
# Sherlogs.jl
If Sherlock Holmes was a number format.

Sherlogs.jl provides a number format `Sherlog64` that behaves like `Float64`, but inspects your code by logging all arithmetic results into a 16bit bitpattern histogram. On the fly.

What's the largest number occuring in your algorithm/model/function/package? What's the smallest? And is your code ready for 16bit? Sherlog will let you know.

A 32bit version is provided as `Sherlog32`, which behaves like `Float32`.

# Example

Using a type-flexible algorithm like [Lorenz96](https://github.com/milankl/Lorenz96.jl)
```julia
julia> using Sherlogs
julia> using Lorenz96
julia> X = L96(Sherlog64);
julia> lb = return_logbook()
65536-element Array{UInt64,1}:
 0x000000000000103f
 0x00000000000000d0
 0x00000000000000f3
 0x00000000000000ba
 0x000000000000008c
                  ⋮
```
`lb` is now a bitpattern histogram based on `Float16` (by default). This tells us for example that  0 - the zero bitpattern `0x00...00` (i.e. the first entry of `lb`) occured `0x103f` = 4159 times in the execution of L96. Use `return_logbook` to retrieve the bitpattern histogram, use `reset_logbook()` to set the counters back to 0. Other 16bit number formats that are used as bins for the histogram can be used by specifying the parametric type `Sherlog64{T}`
```julia
julia> using SoftPosit
julia> L96(Sherlog64{Posit16})
julia> lb = return_logbook()
julia> lb = return_logbook()
65536-element Array{UInt64,1}:
 0x0000000000000503
 0x000000000000081e
 0x0000000000000187
                  ⋮
 ```
# Performance

Logging the arithmetic results comes with overhead (the allocations are just preallocations).
```julia
julia> using BenchmarkTools
julia> @btime L96(Float64,N=100000);
  32.224 ms (200021 allocations: 97.66 MiB)
julia> @btime L96(Sherlog64,N=100000);
  1.184 s (200021 allocations: 97.66 MiB)
```
which depend on the number system used for binning
```julia
julia> using SoftPosit
julia> @btime L96(Sherlog64{Posit16},N=100000);
  9.322 s (200021 allocations: 97.66 MiB)
```

# Installation
```julia
] add https://github.com/milankl/Sherlogs.jl
```

