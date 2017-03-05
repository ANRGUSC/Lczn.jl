# Inputs:
#
# * l_ests: An array, each element of which is an array containing the
# location estimates for all the test samples at a given location.
# * dist_errs: The location distance errors. Must be of size nlocs
# times nlocs
#
# Output:
# * l_errs: Same as l_ests with each element now representing the
# distance error of the estimate rather than the estimate itself.
function loc_errs(l_ests, dist_errs)
    ncol, nrow = size(dist_errs)
    @test(ncol == nrow)
    nlocs = ncol
    l_errs = Array[]
    for loc in 1:nlocs
        ests = l_ests[loc]
        nests = length(ests)
        d_errs = zeros(nests)
        for s in 1:nests
            d_errs[s] = dist_errs[loc, ests[s]]
        end
        push!(l_errs, d_errs)
    end
    return l_errs
end
