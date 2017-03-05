## Function Arguments
# * data_folder:
#       The name of the data folder that contains the required
#       trace files.
#
# * αv :
#       A range consisting of the fractions (α) of the data to
#       be used for training
#
# * edges:
#       The edges for the empirical pdf estimation
#
# * n:
#       The number of iterations per training data size
#
## Output
# * plts :
#       Plots that show how the estimate error varies on increasing
#       the number of data points used to estimate the prior. The
#       returned vector contains a plot for each location.
function plot_cogimp(data_folder, n = 10, max_bss = 10,
                     αv = 0.5:0.05:0.9, edges = -100:10:-20)

minα = first(αv)
stpα = step(αv)
maxα = last(αv)

nlocs = length(filter(x->ismatch(r"loc", x), readdir(data_folder)))

# Read (all) trace data as an array of arrays
trace = Array[]
locs  = Array[]
for i in 0:nlocs-1
    push!(trace, readcsv(data_folder * "rss$i.csv"))
    push!(locs,  readcsv(data_folder * "loc$i.csv"))
end

# The assumption here is that the traces in all locations have the same
# size. If not, you'll need to update the number of test samples below.
num_ts = Int(floor((1 - maxα) * size(trace[1], 2)))

# Pre-compute the location distance errors
dist_errs = d_errs(locs)

# Data structure to store the cognitive improvement errors
errs_cogimp = Dict()
map_cogimp  = zeros(nlocs, length(αv), n)
mmse_cogimp = zeros(nlocs, length(αv), n)
mede_cogimp = zeros(nlocs, length(αv), n)
fing_cogimp = zeros(nlocs, length(αv), n)

for iter in 1:n, a in 1:length(αv)
    α = αv[a]

    # Separate out the training and test sets from the raw data
    train = Array[]
    test  = Array[]
    for i in 1:nlocs
        tr, te = ttsplit(trace[i], 1-α)
        push!(train, tr[1:max_bss, :])
        push!( test, te[1:max_bss, 1:num_ts])
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

    for l in 1:nlocs
         map_cogimp[l, a, iter] = mean( map_errs[l][:])
        mmse_cogimp[l, a, iter] = mean(mmse_errs[l][:])
        mede_cogimp[l, a, iter] = mean(mede_errs[l][:])
        fing_cogimp[l, a, iter] = mean(fing_errs[l][:])
    end
end

errs_cogimp["map"]  = map_cogimp
errs_cogimp["mmse"] = mmse_cogimp
errs_cogimp["mede"] = mede_cogimp
errs_cogimp["fing"] = fing_cogimp

 map_avg_cogimp = squeeze(mean( map_cogimp, 3), 3)
mmse_avg_cogimp = squeeze(mean(mmse_cogimp, 3), 3)
mede_avg_cogimp = squeeze(mean(mede_cogimp, 3), 3)
#fing_avg_cogimp = squeeze(mean(fing_cogimp, 3), 3)

## Plotting
# Plot the cognitive improvement for different algorithms on the same plot
plts = Array{Any}(nlocs)
#l = 1
for l in 1:nlocs
    plts[l] = scatter(αv,
               [map_avg_cogimp[l, :],
               mmse_avg_cogimp[l, :],
               mede_avg_cogimp[l, :],
#               fing_avg_cogimp[l, :],
               ],
               labels = ["MAP" "MMSE" "MEDE" "FING"],
               markersize  = 8,
               markershape = :auto,
               xlabel = "Fraction of Training Data",
               ylabel = "Distance Error (m)",
               regression = true,
               linewidth = 4,
               );
end
#savefig(plt, "ecdf.pdf")

return plts

end # End of the plot_cogimp function.
