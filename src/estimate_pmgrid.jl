using GadgetDataHandle

"""
    estimate_highres_pmgrid(data::GadgetData)

Estimate the number to put as HIGHRES_PMGRID in Config file.
"""
function estimate_highres_pmgrid(data::GadgetData)
    npart = maximum(get_snap_header(data).npart[1:2])
    return cbrt(npart)
end
