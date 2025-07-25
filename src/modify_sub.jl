
"""
    set_sub_data!(data::GadgetData, fieldname::String;
                  new_data::Union{VecOrMat{<:Real}})

Set `data.sub_data[fieldname]` to `new_data` and return `data`.
"""
function set_sub_data!(data::GadgetData, fieldname::String;
                       new_data::Union{VecOrMat{<:Real}})
    data.sub_data[fieldname] = new_data
    return data
end

"""
    set_sub_data!(data::GadgetFilename, fieldname::String;
                  new_data::Union{VecOrMat{<:Real}})

Return `data` and do nothing.
"""
function set_sub_data!(data::GadgetFilename, fieldname::String;
                       new_data::Union{VecOrMat{<:Real}})
    # no sub_data entry is present, we can this not edit it
    return data
end
