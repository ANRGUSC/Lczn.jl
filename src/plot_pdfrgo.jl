## Parameters

function plot_pdfrgo()

lmax = 16                                      # Length of the square arena (m)
n = 64                                         # Granularity
nO = 12                                         # Number of observations per location per beacon
η = 2.2                                        # Path loss exponent
σ = sqrt(16.6)                                   # Noise standard deviation
ls = lmax/n                                    # Length of each segment
dsc = 0:ls:(n-1)*ls                            # Discretization of the length
dsc = dsc .+ ls/2
𝒳 = [[xi, yj] for xi in dsc, yj in dsc]        # Discretization of the space
B = [[xi, yj] for xi in
    [-1, lmax+1],
    yj in
    [-1, lmax+1]]
nb = length(B[:])                               # Number of beacon stations
B = reshape(B, nb, 1);                          # Array of beacon locations
fname = "res.csv"                               # File location to store the results
r = [Int64(round(n/2)), Int64(round(n/2))]      # Device location Index
𝒳[r[1], r[2]]                                   # Actual Device location

## Generate Samples

# D(i, j, k) gives the distance of the (i,j)'th location from the k'th beacon.
D = zeros(n, n, nb)
for i=1:n, j=1:n, k=1:nb
    D[i, j, k] = norm(𝒳[i,j] - B[k])
end

distLoss = 10η*log10(D)
O = zeros(n, n, nb, nO)
for i=1:nO
    O[:, :, :, i] = -distLoss + rand(Normal(0, σ), n, n, nb)
end

## Compute the pdf

pdfrgo = zeros(n, n, nb, nO)
for i=1:n, j=1:n, k=1:nb
    ogr = Normal(-distLoss[i, j, k], σ)
    pdfrgo[i, j, k, :] = pdf(ogr, O[r[1], r[2], k, :])
end
pdfrgo = squeeze(prod(pdfrgo, 3), 3)
norml = squeeze(sum(pdfrgo, (1, 2)), (1, 2))
for i=1:nO
    pdfrgo[:, :, i] = pdfrgo[:, :, i]/norml[i]
end

## Plot the pdf

x = zeros(n*n)
y = zeros(n*n)
z = zeros(n*n, nO)
for i=1:n, j=1:n
    loc = 𝒳[i, j]
    ind = sub2ind((n, n), i, j)
    x[ind] = loc[1]
    y[ind] = loc[2]
    z[ind, :] = pdfrgo[i, j, :]
end

plts = Array{Plots.Plot{Plots.PyPlotBackend}}(nO)
for i=1:nO
    plts[i] = plot(
                   x, y, z[:, i],
                   st=[:surface],
                   xlabel = L"X",
                   ylabel = L"Y",
                   zlabel = L"f_{\mathbf{R}}(\mathbf{r} | \mathbf{O} = \mathbf{o})",
                   leg=false
                  );
    savefig(plts[i], "pdfrgo_$i.pdf")
end
#plot(x, y, z[:, 2], st=[:surface], leg=false)

end
