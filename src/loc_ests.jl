# Inputs:
# * est_fn: A function that returns a location estimate given p(r|O)
# * pdfs_test: The posterior pdf for each location and
# test observation vector, stored as an array of arrays.
# * dist_errs: The location distance errors. Must be of size nlocs
# times nlocs
#
# Output:
# * l_ests: An array. Each element is an array containing the location
# estimates for all the test samples at a given location.
#
function loc_ests(est_fn, pdfs_test, dist_errs)
    nlocs = length(pdfs_test)
    l_ests = Array[]
    for loc in 1:nlocs
        pmatrix = pdfs_test[loc]
        (nrow, ncol) = size(pmatrix)
        ests = Vector(ncol)
        for s in 1:ncol
            ests[s] = est_fn(pmatrix[:, s], dist_errs)
        end
        push!(l_ests, ests)
    end
    return l_ests
end
