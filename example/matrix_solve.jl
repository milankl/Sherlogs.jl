using Sherlogs, PyPlot, StatsBase, Printf

A = Sherlog64.(rand(1000,1000))
b = Sherlog64.(rand(1000))

# trigger logging of A,b
A .+ 0
b .+ 0
lb0 = get_logbook()

# LU decomposition
x = A\b
lb1 = get_logbook()

H0 = entropy(lb0.logbook/sum(lb0),2)
H1 = entropy(lb1.logbook/sum(lb1),2)

## PLOT
H0s = @sprintf "%.2f" H0
H1s = @sprintf "%.2f" H1

f = [1/512,1/4,1,4,512,Inf,-1/512,-1/4,-1,-4,-512,-Inf]
fs = ["⅟512","¼","1","4","512","∞","-⅟512","-¼","-1","-4","-512","-∞"]
fi = Int.(reinterpret.(UInt16,Float16.(f)))

fig,ax = subplots(1,1,figsize=(8,3))

ax.plot(lb0.logbook/sum(lb0)*100,label="U(0,1), H=$H0s bit")
ax.plot(lb1.logbook/sum(lb1)*100,label="A\\b,      H=$H1s bit")

ax.legend()
ax.set_title("Float16 bitpattern histogram",loc="left")
ax.set_ylabel("[%]")
ax.set_xticks(fi)
ax.set_xticklabels(fs)
ax.set_xlim(0,2^16)

tight_layout()
savefig("matrixsolve.png")
