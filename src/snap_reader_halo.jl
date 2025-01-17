using GadgetIO

# snapshot reading functions
"""
    get_snap_data(data::GadgetFilename, fieldname::String; parttype::Int64=0)

Read snapshot data from `data.snap` with `fieldname` and `parttype`.
"""
function get_snap_data(data::GadgetFilename, fieldname::String; parttype::Int64=0)
    return read_block(data.snap, fieldname, parttype=parttype)
end
"""
    get_snap_data(data::GadgetFilenameWithData, fieldname::String; parttype::Int64=0)

Get snapshot data from `data.snap_data` if present, otherwise read from `data.snap`.
"""
function get_snap_data(data::GadgetFilenameWithData, fieldname::String; parttype::Int64=0)
    if haskey(data.snap_data,(fieldname,parttype))
        return data.snap_data[(fieldname, parttype)]
    else
        return read_block(data.snap, fieldname, parttype=parttype)
    end
end
"""
    get_snap_data(data::GadgetOnlyData, fieldname::String; parttype::Int64=0)

Get snapshot data from `data.snap_data`.
"""
function get_snap_data(data::GadgetOnlyData, fieldname::String; parttype::Int64=0)
    return data.snap_data[(fieldname, parttype)]
end

# snapshot reading functions to add the data just read
"""
    get_snap_data!(data::GadgetData, fieldname::String; parttype::Int64=0)

See `get_snap_data(data::GadgetData, fieldname::String; parttype::Int64=0)`
"""
function get_snap_data!(data::GadgetData, fieldname::String; parttype::Int64=0)
    return get_snap_data(data, fieldname, parttype=parttype)
end
"""
    get_snap_data(data::GadgetFilenameWithData, fieldname::String; parttype::Int64=0)

Get snapshot data from `data.snap_data` if present, otherwise read from `data.snap` and save in `data.snap_data`.
"""
function get_snap_data!(data::GadgetFilenameWithData, fieldname::String; parttype::Int64=0)
    if haskey(data.snap_data,(fieldname,parttype))
        return data.snap_data[(fieldname, parttype)]
    else
        new_snap_data = read_block(data.snap, fieldname, parttype=parttype)
        data.snap_data[(fieldname,parttype)] = new_snap_data
        return new_snap_data
    end
end

# snaphot reading functions for particles in box
"""
    get_snap_data_in_box(data::GadgetFilename, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

Read snapshot data from `data.snap` with `fieldname` and `parttype`.
"""
function get_snap_data_in_box(data::GadgetFilename, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    return read_particles_in_box(data.snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=false)
end
"""
    get_snap_data_in_box(data::GadgetFilenameWithData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

Get snapshot data from `data.snap_data` if present, otherwise read from `data.snap`.
"""
function get_snap_data_in_box(data::GadgetFilenameWithData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    if haskey(data.snap_data,(fieldname,parttype))
        pos = get_snap_data(data,"POS",parttype=0)
        index = (corner_lowerleft[1] .< pos[1,:] .< corner_upperright[1]) .&
            (corner_lowerleft[2] .< pos[2,:] .< corner_upperright[2]) .&
            (corner_lowerleft[3] .< pos[3,:] .< corner_upperright[3])
        if ndims(data.snap_data[(fieldname, parttype)]) == 1
            return data.snap_data[(fieldname, parttype)][index]
        else # == 2
            return data.snap_data[(fieldname, parttype)][:,index]
        end
    else
        return read_particles_in_box(data.snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=false)
    end
end
"""
    get_snap_data_in_box(data::GadgetOnlyData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

Get snapshot data from `data.snap_data`.
"""
function get_snap_data_in_box(data::GadgetOnlyData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    pos = get_snap_data(data,"POS",parttype=0)
    index = (corner_lowerleft[1] .< pos[1,:] .< corner_upperright[1]) .&
        (corner_lowerleft[2] .< pos[2,:] .< corner_upperright[2]) .&
        (corner_lowerleft[3] .< pos[3,:] .< corner_upperright[3])
    if ndims(data.snap_data[(fieldname, parttype)]) == 1
        return data.snap_data[(fieldname, parttype)][index]
    else # == 2
        return data.snap_data[(fieldname, parttype)][:,index]
    end
end

# snapshot reading functions for particles in box to add the data just read
"""
    get_snap_data_in_box!(data::GadgetData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

See `get_snap_data_in_box(data::GadgetData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)`
"""
function get_snap_data_in_box!(data::GadgetData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    return get_snap_data_in_box(data, fieldname, corner_lowerleft, corner_upperright, parttype=parttype)
end
"""
    get_snap_data_in_box(data::GadgetFilenameWithData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

Get snapshot data from `data.snap_data` if present, otherwise read from `data.snap` and save in `data.snap_data`.
"""
function get_snap_data_in_box!(data::GadgetFilenameWithData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    if haskey(data.snap_data,(fieldname,parttype))
        return get_snap_data_in_box(data, fieldname, corner_lowerleft, corner_upperright, parttype=parttype)
    else
        new_snap_data = read_particles_in_box(data.snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=false)
        data.snap_data[(fieldname,parttype)] = new_snap_data
        return new_snap_data
    end
end
