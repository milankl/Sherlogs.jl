function scent(f::Function,r::Real)
    if f(r)
        i = st_index[1]
        if i <= nstackframes
            ST[:,i] = stacktrace()[2:4]    # 1 is the line where scent is called
            if st_index[1] < nstackframes
                st_index[1] += 1
            else
                st_index[1] = 1
                @warn "DrWatson reached $nstackframes, the maximum number of stackframes."
            end
        end
    end
end

empty_symbol = Symbol("")
const unknown_st = Base.StackTraces.StackFrame(empty_symbol,empty_symbol,-1,nothing,true,false,0)

const nstackframes = 10000      # quite arbitrary for the moment
const stackframe_depth = 3

const ST = [unknown_st for _ in 1:stackframe_depth, _ in 1:nstackframes]
const st_index = [1]

get_stacktrace(i::Int=1) = ST[:,i]
get_stacktraces() = ST[:,1:st_index[1]-1]
get_st_index() = st_index[1]
