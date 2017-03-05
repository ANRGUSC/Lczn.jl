## Input
# * locs: An array of location coordinates
#
## Output:
# * dist_errs: A (symmetric) matrix of distance errors

function d_errs(locs)

nlocs = length(locs)
dist_errs = zeros(nlocs, nlocs)
for i in 1:nlocs, j in 1:nlocs
    if i != j
        dist_errs[i, j] = norm(locs[i] - locs[j])
    end
end

return dist_errs
end
