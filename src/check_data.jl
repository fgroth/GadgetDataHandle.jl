
function has_snap_block(data::GadgetData, block_name::String;
                        parttype::Int64=0)
    return haskey(data.snap_data,(fieldname,parttype))
end
function has_snap_block(data::GadgetFilename, block_name::String;
                        parttype::Int64=0)
    # GadgetFilename type does not contain snap_data.
    return false
end

function remove_snap_block!(data::GadgetData, block_name::String;
                            parttype::In64=0)
    if has_snap_block(data, block_name, parttype=parttype)
        delete!(data.snap_data, (block_name,parttype))
        return true
    else
        return false
    end
end

# add function to add data, which returns true / false, depending whether it was appended or already there? / option to return that?!
