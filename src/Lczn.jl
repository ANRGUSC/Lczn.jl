module Lczn

using Plots
using LaTeXStrings
using Distances
using Distributions
using StatsBase
using Base.Test

# Use Python's matplotlib backend for plots
pyplot()

## Helper Functions
include("bins.jl")
include("asympdf.jl")
include("ttsplit.jl")
include("ecdf_fing.jl")
include("flat_errs.jl")
include("loc_errs.jl")
include("loc_ests.jl")
include("d_errs.jl")

## Estimation
include("fing.jl")
include("mede.jl")
include("mmse.jl")
include("mape.jl")
include("ests_errs.jl")

## Plotting Functions
include("plot_asympdf.jl")
include("plot_pdfrgo.jl")
include("plot_pdfogr.jl")
include("plot_datacdfs.jl")
include("plot_cogimp.jl")

end
