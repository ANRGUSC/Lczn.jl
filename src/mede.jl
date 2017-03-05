# Inputs:
# * P: A vector of the posterior pdf of the location r given the
# observation vector O
# * dist_errs: The location distance errors. Must be of size nlocs
# times nlocs
# Output:
# * A location estimate ∈ [1, 2, ..., nlocs]

function mede(P, dist_errs)
    ncol, nrow = size(dist_errs)
    @test(ncol == nrow)
    nlocs = ncol
    l_errs = zeros(nlocs)
    for r in 1:nlocs
        l_errs[r] = vecdot(dist_errs[:, r], P)
    end
    return indmin(l_errs)
end
