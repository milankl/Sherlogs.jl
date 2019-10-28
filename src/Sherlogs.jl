module Sherlogs

export Sherlog64,Sherlog32,Sherlog16,set_logbook,reset_logbook,return_logbook

import Base: (+), (-), (*), (/)

const n16 = 2^16                        # number of bitpatterns for a 16bit number format
const logbook = zeros(UInt64,n16)       # bitpattern histogram array

const idx = [1]                         # index for stacktrace array, kept in array for mutability
const idxmax = 1001
const stmax = 5
# stacktrace array to store stacktraces
const SA = Array{Base.StackTraces.StackFrame,2}(undef,stmax,idxmax-1)

include("Sherlog64.jl")
include("Sherlog32.jl")
include("Sherlog16.jl")
include("logbook.jl")

end
