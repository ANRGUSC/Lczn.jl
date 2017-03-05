# Inputs:
# * data: The data set to be split. We assume that the data is in a
# matrix form.
# * α : Fraction of data to be used for testing
# Output:
# * tr_data: 'Training' data. 1-α fraction of the data.
# * te_data: 'Testing' data. α fraction of the data.

function ttsplit(data, α)
    nrow, ncol = size(data)
    num_test_samples = Int(floor(α * ncol))
    test_ids  = sample(1:ncol, num_test_samples, replace = false)
    train_ids = setdiff(1:ncol, test_ids)
    tr_data = data[:, train_ids]
    te_data = data[:, test_ids]
    return tr_data, te_data
end

