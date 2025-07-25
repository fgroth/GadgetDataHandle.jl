
"""
    set_snap_data!(data::GadgetData, fieldname::String;
                   parttype::Int64=0, new_data::Union{VecOrMat{<:Real}})

Set `data.snap_data[(fieldname, parttype)]` to `new_data` and return `data`.
"""
function set_snap_data!(data::GadgetData, fieldname::String;
                        parttype::Int64=0, new_data::Union{VecOrMat{<:Real}})
    data.snap_data[(fieldname, parttype)] = new_data
    return data
end

"""
    set_snap_data!(data::GadgetFilename, fieldname::String;
                   parttype::Int64=0, new_data::Union{VecOrMat{<:Real}})

Return `data` and do nothing.
"""
function set_snap_data!(data::GadgetFilename, fieldname::String;
                        parttype::Int64=0, new_data::Union{VecOrMat{<:Real}})
    # no snap_data entry is present, we can this not edit it
    return data
end
