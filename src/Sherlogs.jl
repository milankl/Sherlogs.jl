module Sherlogs

    export Sherlog64,Sherlog32,Sherlog16,
            DrWatson64,DrWatson32,DrWatson16,
            LogBook,reset_logbook,reset_logbooks,
            get_logbook,get_logbooks,
            entropy

    import Base: (+), (-), (*), (/), (^)

    import StatsBase: entropy

    include("logbook.jl")
    include("Sherlog64.jl")
    include("Sherlog32.jl")
    include("Sherlog16.jl")
    include("DrWatson64.jl")

end
