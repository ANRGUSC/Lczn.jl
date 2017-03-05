# Input:
# * o: A (scalar) observation
# * edges: The edges for the pdf bins.
#
# Output:
# * ind: An index to the pdf vector.
#
# Notes: The function basically computes which 'bin'
# in edges your observation would fall into.

function bins(o, edges=-100:10:-20)
    @test(o <= last(edges))
    @test(o >= first(edges))
    for ind in 1:length(edges)
        if o <= edges[ind+1]
            return ind
        end
    end
end

