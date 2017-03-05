## Function Arguments
# * tracefile: The name of the .csv trace file that is assumed to be
# present in the current directory. It is assumed that each row of the
# csv file contains the RSSI readings from one access point.
#
# * rows: The rows, whose histograms are to be computed. It is assumed
# that the IDs are valid.
#
## Output
# * $tracefile_pdfogr_$i : For each $i ∈ ids, a histogram of the RSSI
# values are written to disk.

function plot_pdfogr(tracefile, rows)

# Read the CSV file
trace = readcsv(tracefile)

# Array of plots
plts = Array{Any}(length(rows))
for i in 1:length(rows)
    row = rows[i]
    plts[i] = histogram(trace[row,:],
                        xlabel = L"O",
                        ylabel = L"\hat{f}_{O}(o | \mathbf{R} = \mathbf{r})",
                        normalize = true,
                        leg = false,
                        bins = -100:2:-30,
                       );
    savefig(plts[i], tracefile[end-7:end-4]*"_pdfogr_$row.pdf")
end

end
