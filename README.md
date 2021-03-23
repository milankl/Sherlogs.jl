[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://img.shields.io/badge/repo_status-active-brightgreen)](https://www.repostatus.org/#active)
[![Travis](https://img.shields.io/travis/com/milankl/Sherlogs.jl?label=Linux%20%26%20osx&logo=travis)](https://travis-ci.com/milankl/Sherlogs.jl)
[![AppVeyor](https://img.shields.io/appveyor/ci/milankl/Sherlogs-jl?label=Windows&logo=appveyor&logoColor=white)](https://ci.appveyor.com/project/milankl/Sherlogs-jl)
[![Cirrus CI](https://img.shields.io/cirrus/github/milankl/Sherlogs.jl?label=FreeBSD&logo=cirrus-ci&logoColor=white)](https://cirrus-ci.com/github/milankl/Sherlogs.jl)
[![DOI](https://zenodo.org/badge/214412644.svg)](https://zenodo.org/badge/latestdoi/214412644)

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

julia> lb = get_logbook()
65536-element LogBook(1091, 192, 234, 181, 206, … , 0, 0, 0, 0, 0, 0)
```
`lb` is now a Float16 (by default) bitpattern histogram `LogBook`. 
This tells us for example that  0 - the zero bitpattern `0x00...00` (i.e. the first entry of `lb`) 
occured 1091 times in the LU decomposition (which is used in the \\-operation). 
Use `get_logbook()` to retrieve the `LogBook`, use `reset_logbook()` to set
the counters back to 0. Other 16bit number formats that are used as bins for
the histogram can be used by specifying the parametric type `Sherlog64{T,i}`.
The second parameter `i` (in 1:32) is an integer that specifies which logbook to use. 

# Example bitpattern histogram

![bitpattern](figs/matrixsolve.png?raw=true "Bitpattern Histogram")

This is the bitpattern histogram for the uniformly distributed U(0,1) input data, once represented with `Float16` (blue). Using `Sherlog64` inside the solver `A\b`, creates a bitpattern histogram for that algorithm (LU-decomposition) (orange).
The x-axis is ranging from bitpattern `0x0000` to `0xffff` but for readability relabelled with the respective decimal numbers. The entropy is denoted with `H`. A uniform distribution has maximum entropy of 16bit. The script for this example can be found [here](https://github.com/milankl/Sherlogs.jl/blob/master/example/matrix_solve.jl))

# Performance

Logging the arithmetic results comes with overhead (the allocations are just preallocations).
```julia
julia> using BenchmarkTools, Lorenz96, BFloat16s
julia> @btime L96(Float32,N=100000);
  26.321 ms (200023 allocations: 97.66 MiB)
julia> @btime L96(Sherlog32{BFloat16,1},N=100000);
  346.052 ms (200023 allocations: 97.66 MiB)
julia> @btime L96(Sherlog32{Float16,1},N=100000);
  1.098 s (200023 allocations: 97.66 MiB)
```
which depends on the number system used for binning.

# Installation
Sherlogs is a registered package, do
```julia
julia> ] add Sherlogs
```
