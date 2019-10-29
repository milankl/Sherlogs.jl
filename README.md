[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://img.shields.io/badge/repo_status-active-brightgreen?style=flat-square)](https://www.repostatus.org/#active)
[![Travis](https://img.shields.io/travis/com/milankl/Sherlogs.jl?label=Linux%20%26%20osx&logo=travis&style=flat-square)](https://travis-ci.com/milankl/Sherlogs.jl)
[![AppVeyor](https://img.shields.io/appveyor/ci/milankl/Sherlogs-jl?label=Windows&logo=appveyor&logoColor=white&style=flat-square)](https://ci.appveyor.com/project/milankl/Sherlogs-jl)
[![Cirrus CI](https://img.shields.io/cirrus/github/milankl/Sherlogs.jl?label=FreeBSD&logo=cirrus-ci&logoColor=white&style=flat-square)](https://cirrus-ci.com/github/milankl/Sherlogs.jl)

# Sherlogs.jl
If Sherlock Holmes was a number format.

Sherlogs.jl provides a number format `Sherlog64` that behaves like `Float64`, but inspects your code by logging all arithmetic results into a 16bit bitpattern histogram. On the fly.

What's the largest number occuring in your algorithm/model/function/package? What's the smallest? And is your code ready for 16bit? Sherlog will let you know.

A 32bit version is provided as `Sherlog32`, which behaves like `Float32`.
A 16bit version is provided as `Sherlog16{T}`, which uses `T` for computations as well as for logging. If `T` not provided it falls back to `Float16`.

# Example

What are the numbers that occur when solving a linear equation system?

```julia
julia> using Sherlogs
julia> A = Sherlog64.(rand(1000,1000));
julia> b = Sherlog64.(rand(1000));
julia> x = A\b;
julia> lb = return_logbook()
65536-element Array{UInt64,1}:
 0x00000000000004cf
 0x0000000000000076
 0x00000000000000f9
 0x000000000000010e
 0x0000000000000127
 0x00000000000000fb
 0x000000000000010f
                  ⋮
```
`lb` is now a Float16 (by default) bitpattern histogram. This tells us for example that  0 - the zero bitpattern `0x00...00` (i.e. the first entry of `lb`) occured `0x04cf` = 1231 times in the LU decomposition (which is used in the \-operation). Use `return_logbook()` to retrieve the bitpattern histogram, use `reset_logbook()` to set the counters back to 0. Other 16bit number formats that are used as bins for the histogram can be used by specifying the parametric type `Sherlog64{T}`.

# Example bitpattern histogram
![bitpattern](figs/matrixsolve.png?raw=true "Bitpattern Histogram")

([script](https://github.com/milankl/example/matrix_solve.jl)) This is the bitpattern histogram for the uniformly distributed U(0,1) input data, once represented with `Float16` (blue). Using `Sherlog64` inside the solver `A\b`, creates a bitpattern histogram for that algorithm (LU-decomposition) (orange).
The x-axis is ranging from bitpattern `0x0000` to `0xffff` but for readability relabelled with the respective decimal numbers. The entropy is denoted with `H`. A uniform distribution has maximum entropy of 16bit.

# Performance

Logging the arithmetic results comes with overhead (the allocations are just preallocations).
```julia
julia> using BenchmarkTools
julia> @btime L96(Float64,N=100000);
  32.224 ms (200021 allocations: 97.66 MiB)
julia> @btime L96(Sherlog64,N=100000);
  1.184 s (200021 allocations: 97.66 MiB)
```
which depends on the number system used for binning
```julia
julia> using SoftPosit
julia> @btime L96(Sherlog64{Posit16},N=100000);
  9.322 s (200021 allocations: 97.66 MiB)
```

# Installation
```julia
] add https://github.com/milankl/Sherlogs.jl
```
