
"""
    has_snap_data(data::GadgetData, fieldname::String;
                  parttype::Int64=0)

Return if `fieldname` for given `parttype` is already part of `data.snap_data`.
"""
function has_snap_data(data::GadgetData, fieldname::String;
                       parttype::Int64=0)
    return haskey(data.snap_data,(fieldname,parttype))
end
function has_snap_data(data::GadgetFilename, fieldname::String;
                       parttype::Int64=0)
    # GadgetFilename type does not contain snap_data.
    return false
end


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
    has_sub_data(data::GadgetData, fieldname::String)

Return if `fieldname` is already part of `data.sub_data`.
"""
function has_sub_data(data::GadgetData, fieldname::String)
    return haskey(data.sub_data, fieldname)
end
function has_sub_data(data::GadgetFilename, fieldname::String)
    # GadgetFilename type does not contain sub_data.
    return false
end


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
