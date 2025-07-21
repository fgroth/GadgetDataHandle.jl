

# functions to remove data and free memory
"""
    remove_snap_data!(data::GadgetFilename, fieldname::String; parttype::Int64=0)

Return `false`, as no data is stored for `GadgetFilenamme` type.
"""
function remove_snap_data!(data::GadgetFilename, fieldname::String; parttype::Int64=0)
    return false
end

"""
    remove_snap_data!(data::GadgetData, fieldname::String; parttype::Int64=0)

Remove data from `snap_data` structure. Return `true`, if it was removed and present before, otherwise `false`.
"""
function remove_snap_data!(data::GadgetData, fieldname::String; parttype::Int64=0)
    if has_snap_data(data, fieldname, parttype=parttype)
        delete!(data.snap_data, (fieldname,parttype))
        return true
    else
        return false
    end
end

# same for subfind blocks

"""
    remove_sub_data!(data::GadgetFilename, fieldname::String)

Return `false`, as no data is stored for `GadgetFilenamme` type.
"""
function remove_sub_data!(data::GadgetFilename, fieldname::String)
    return false
end

"""
    remove_sub_data!(data::GadgetFilenameWithData, fieldname::String)

Remove data from `sub_data` structure. Return `true`, if it was removed and present before, otherwise `false`.
"""
function remove_sub_data!(data::GadgetData, fieldname::String)
    if has_sub_data(data, fieldname)
        delete!(data.sub_data, fieldname)
        return true
    else
        return false
    end
end
