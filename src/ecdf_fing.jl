# Input:
# * train: The training data from which to compute the empirical pdf and
# fingerprint. It is assumed that this is the training data for a given
# location and base station.
#
# * edges: The edges for the pdf bins.
#
# Output:
# * epdf: The empirical pmf of the data
# * fing: The fingerprint of the date

function epdf_fing(train, edges)
    h = fit(Histogram, train, edges)
    epdf = h.weights/sum(h.weights)
    fing = mean(train)
    return epdf, fing
end
