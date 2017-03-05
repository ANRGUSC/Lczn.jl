# Inputs:
# * P: A vector of the posterior pdf of the location r given the
# observation vector O
# * r: The true location. r ∈ [1, 2, ..., nlocs]
# * dist_errs: The location distance errors. Must be of size nlocs
# times nlocs
# Output:
# * A location estimate ∈ [1, 2, ..., nlocs]

function mape(P, dist_errs)
    return indmax(P)
end

function mape(P)
    return indmax(P)
end
