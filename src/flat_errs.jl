# Inputs:
# * l_errs: An array of arrays.
# Output:
# * The elements of l_errs in a single flat vector
function flat_errs(l_errs)
    [err for d_errs in l_errs for err in d_errs]
end
