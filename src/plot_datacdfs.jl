## Function Arguments
# * data_folder:
#       The name of the data folder that contains the required
#       trace files
#
# * α :
#       Fraction of data to be used for testing
#
# * max_bss:
#       The number of base stations to use. For a given value of
#       max_bss, the base stations with IDs 1 to max_bss are used
#
# * edges:
#       The edges for the empirical pdf estimation
#
## Output
# * plt:
#       A plot that shows the error cdfs of different localization
#       algorithms

function plot_datacdfs(data_folder, α=0.1, max_bss=10, edges=-100:10:-20)

maxO = first(edges)
minO = last(edges)

nlocs = length(filter(x->ismatch(r"loc", x), readdir(data_folder)))

# Read (all) trace data as an array of arrays
trace = Array[]
locs  = Array[]
for i in 0:nlocs-1
    push!(trace, readcsv(data_folder * "rss$i.csv"))
    push!(locs,  readcsv(data_folder * "loc$i.csv"))
end

# Pre-compute the location distance errors
dist_errs = d_errs(locs)

# Separate out the training and test sets from the raw data
train = Array[]
test  = Array[]
for i in 1:nlocs
    tr, te = ttsplit(trace[i], α)
    push!(train, tr[1:max_bss, :])
    push!( test, te[1:max_bss, :])
end

# Computed the estimates their associated errors
ests, errs = ests_errs(train, test, dist_errs, max_bss, edges)

map_ests = ests["map"]
map_errs = errs["map"]
map_ecdf = ecdf(flat_errs(map_errs))

mmse_ests = ests["mmse"]
mmse_errs = errs["mmse"]
mmse_ecdf = ecdf(flat_errs(mmse_errs))

mede_ests = ests["mede"]
mede_errs = errs["mede"]
mede_ecdf = ecdf(flat_errs(mede_errs))

fing_errs = errs["fing"]
fing_ecdf = ecdf(flat_errs(fing_errs))

## Plotting
# Plot the empirical cdfs for different algorithms on the same plot
plt = plot([map_ecdf, mmse_ecdf, mede_ecdf, fing_ecdf],
           0, 4,
           labels = ["MAP" "MMSE" "MEDE" "FING"],
           linewidth = 4,
           );
#savefig(plt, "ecdf.pdf")

end # End of the plot_cogimp function.
