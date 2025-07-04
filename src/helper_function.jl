
"""
    has_key_files(data::GadgetData)

Determine if key files exist for given `data.snap`.
"""
function has_key_files(data::GadgetData)
    if hasproperty(data, :snap)
        return isfile(data.snap*".0.key")
    else
        error("Type of data does not contain information on snapshot name. Cannot determine if key files exist.")
    end
end
