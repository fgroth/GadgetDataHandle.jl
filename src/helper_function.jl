
"""
    has_key_files(data::GadgetData)

Return if key files exist for given `data.snap`.
"""
function has_key_files(data::GadgetData)
    return isfile(data.snap*".key.index") && isfile(data.snap*".0.key")
end
function has_key_files(data::GadgetOnlyData)
    return false
end
