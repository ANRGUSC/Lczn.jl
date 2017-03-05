# Inputs:
#
# * O: A vector of observations
# * fingerprint: A matrix of size nlocs times max_bss that stores the
# average signal strength vector for each location.
#
# Output:
# * A location estimate ∈ [1, 2, ..., nlocs]
function fing(O, fingerprint)
    (nlocs, max_bss) = size(fingerprint)
    @test(length(O) == max_bss)

    l_errs = zeros(nlocs)
    for loc in 1:nlocs
        l_errs[loc] = norm(vec(O) - vec(fingerprint[loc, :]))
    end
    return indmin(l_errs)
end

