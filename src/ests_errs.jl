## Inputs
# * train: The training data set
# * test : The testing  data set
#
# * dist_errs: The location distance errors. Must be of size nlocs
# times nlocs
#
# * max_bss:
#       The number of base stations to use. For a given value of
#       max_bss, the base stations with IDs 1 to max_bss are used
#
# * edges:
#       The edges for the empirical pdf estimation
#
## Output
# * ests: A dictionary with the estimated locations for
#         MAP, MMSE, MEDE, FING
# * errs: A dictionary with the estimated distance errors for
#         MAP, MMSE, MEDE, FING

function ests_errs(train, test, dist_errs, max_bss, edges)

nr, nc = size(dist_errs)
@test nr == nc
nlocs = nr

# For each location and base station, compute the empirical pdf and
# store it as an array. Also compute the average signal strength
# vector at that location.
ogr_epdfs = Matrix(nlocs, max_bss)
fingerprint = Matrix(nlocs, max_bss)
for loc = 1:nlocs, ap = 1:max_bss
    ogr_epdfs[loc, ap], fingerprint[loc, ap] = epdf_fing(train[loc][ap, :], edges)
end

# Inputs:
# * O: A vector of observations. The vector must have length max_bss
# * r: A scalar indicating the location. Must lie between 1 and nlocs
# Output:
# * p(O|r): The pdf of the observation vector o given the location r.
# Note that the observations are assumed to be independent
function pogr(O, r)
    @test(length(O) == max_bss)
    @test(r >= 1 && r <= nlocs)

    prod = 1.0
    for ap in 1:length(O)
        prod = prod * ogr_epdfs[r, ap][bins(O[ap])]
    end
    return prod
end

# Inputs:
# * O: A vector of observations. The vector must have length max_bss
# * r: A scalar indicating the location. Must lie between 1 and nlocs
# Output:
# * p(r|O): The posterior pdf of the location r given the observation
# vector O
function prgo(r, O)
    @test(length(O) == max_bss)
    @test(r >= 1 && r <= nlocs)

    dinom = 0.0
    for loc in 1:nlocs
        dinom = dinom + pogr(O, loc)
    end
    return pogr(O, r)/dinom
end

# Inputs:
# * O: A vector of observations. The vector must have length max_bss
# Output:
# * p(r|O): A vector of the posterior pdf of the location r given the
# observation vector O
function pdfo(O)
    pdf_o = zeros(nlocs)
    for loc in 1:nlocs
        pdf_o[loc] = prgo(loc, O)
    end
    return pdf_o
end

# For each location and test observation vector,
# * compute the posterior pdf
# * compute the fingerprint estimate
pdfs_test = Array[]
fing_ests = Array[]
for loc in 1:nlocs
    test_samples = test[loc]
    (nrow, ncol) = size(test_samples)
    pmatrix = zeros(nlocs, ncol)
    ests = Vector(ncol)
    for s in 1:ncol
        O = test_samples[1:max_bss, s]
        pmatrix[:, s] = pdfo(O)
        ests[s] = fing(O, fingerprint)
    end
    push!(pdfs_test, pmatrix)
    push!(fing_ests, ests)
end

## Location Estimate and CDF Calculation
# For each posterior pdf, compute the location estimate using:
# * MAP
# * MMSE
# * MEDE
# * Traditional fingerprinting
map_ests = loc_ests(mape, pdfs_test, dist_errs)
map_errs = loc_errs(map_ests, dist_errs)
map_ecdf = ecdf(flat_errs(map_errs))

mmse_ests = loc_ests(mmse, pdfs_test, dist_errs)
mmse_errs = loc_errs(mmse_ests, dist_errs)
mmse_ecdf = ecdf(flat_errs(mmse_errs))

mede_ests = loc_ests(mede, pdfs_test, dist_errs)
mede_errs = loc_errs(mede_ests, dist_errs)
mede_ecdf = ecdf(flat_errs(mede_errs))

fing_errs = loc_errs(fing_ests, dist_errs)
fing_ecdf = ecdf(flat_errs(fing_errs))

ests = Dict()
errs = Dict()

ests["map"]  = map_ests
ests["mmse"] = mmse_ests
ests["mede"] = mede_ests
ests["fing"] = fing_ests

errs["map"]  = map_errs
errs["mmse"] = mmse_errs
errs["mede"] = mede_errs
errs["fing"] = fing_errs

ests, errs
end
