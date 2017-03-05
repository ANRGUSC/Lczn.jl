using Lczn
using Base.Test

tests = ["bins"]

println("Running tests:")

for t in tests
    println(" * $(t)")
    include("$(t).jl")
end
