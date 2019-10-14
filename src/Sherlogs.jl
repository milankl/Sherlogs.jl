module Sherlogs

export Sherlog64,set_logbook,reset_logbook,return_logbook

import Base: (+), (-), (*), (/)

const n16 = 2^16                      # number of bitpatterns for a 16bit number format
const logbook = zeros(UInt64,n16)     # bitpattern histogram array

include("Sherlog64.jl")
include("logbook.jl")

end
