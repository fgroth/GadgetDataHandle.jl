using GadgetIO

"""
    has_snap_block(data::GadgetData, fieldname::String;
                   parttype::Int64=0)

Return if `data` contains `fieldname` for `parttype`, either within `data.snap_data` or within `data.snap`.
"""
function has_snap_block(data::GadgetData, fieldname::String;
                        parttype::Int64=0)
    if has_snap_data(data, fieldname, parttype=parttype)
        return true
    else
        return Bool(block_present(data.snap, fieldname) && GadgetIO.check_info(data.snap, fieldname).is_present[parttype+1])
    end
end
function has_snap_block(data::GadgetOnlyData, fieldname::String;
                        parttype::Int64=0)
    # GadgetOnlyData has no snapshot name. We thus cannot check within the snapshot, but only stored data.
    return has_snap_data(data, fieldname, parttype=parttype)
end

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


"""
    has_sub_block(data::GadgetData, fieldname::String;
                  parttype::Int64=0)

Return if `data` contains `fieldname` for `parttype`, either within `data.sub_data` or within `data.sub`.
"""
function has_sub_block(data::GadgetData, fieldname::String;
                       parttype::Int64=0)
    if has_sub_data(data, fieldname, parttype=parttype)
        return true
    else
        return Bool(block_present(data.sub, fieldname) && GadgetIO.check_info(data.sub, fieldname).is_present[parttype+1])
    end
end
function has_sub_block(data::GadgetOnlyData, fieldname::String;
                       parttype::Int64=0)
    # GadgetOnlyData has no group file name. We thus cannot check within the group file, but only stored data.
    return has_sub_data(data, fieldname, parttype=parttype)
end

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
