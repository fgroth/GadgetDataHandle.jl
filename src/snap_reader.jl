using GadgetIO

# allow to use selection function
"""
    evaluate_selection_function_if_necessary(data;
                                             parttype::Int64=0, reading_function::Function=read_block)

Check if selection function has been evaluated already and otherwise evaluate it now.
"""
function evaluate_selection_function_if_necessary(data::GadgetData;
                                                  parttype::Int64=0, reading_function::Function=read_block)
    if has_snap_block(data,"SELECTION",parttype=parttype) && (parttype in data.select_particle_types)
        # the selection functionhas been calculated already
        return data.snap_data[("SELECTION",parttype)]
    else
        if parttype in data.select_particle_types
            # we have to evaluate the selection function
            data.snap_data[("SELECTION",parttype)] = data.selection_function(data, reading_function=reading_function)
            return data.snap_data[("SELECTION",parttype)]
        else
            # all particles should be included
            data.snap_data[("SELECTION",parttype)] = :;
            return data.snap_data[("SELECTION",parttype)]
        end
    end
end
function evaluate_selection_function_if_necessary(data::GadgetFilename;
                                                  parttype::Int64=0, reading_function::Function=read_block)
    # function specialization, as GadgetFilename does not contain snap_data.
    if haskey(data.snap_selection,parttype) && (parttype in data.select_particle_types)
        # the selection functionhas been calculated already
        return data.snap_selection[parttype]
    else
        if parttype in data.select_particle_types
            # we have to evaluate the selection function
            data.snap_selection[parttype] = data.selection_function(data, reading_function=reading_function)
            return data.snap_selection[parttype]
        else
            # all particles should be included
            data.snap_data[parttype] = :;
            return data.snap_selection[parttype]
        end
    end
end

"""
    restrict_to_selection(block_data::Array, selection)

Select a subset of block_data, taking care if dimensionality.
"""
function restrict_to_selection(block_data::Array, selection)
    if ndims(block_data) == 1
        return block_data[selection]
    else
        return block_data[:, selection]
    end
end


"""
    read_block_with_corrections(snap::String, fieldname::String; parttype::Int64,
                                h::Union{Nothing,SnapshotHeader}=nothing)

Read block, but include some customized corrections such as for the velocity if blocks start with `"VEL"`, `"VRMS"`, `"VBLK"`, `"VTAN"`, `"VRAD"` and end with `"C"`.
Also compare `read_block` from `GadgetIO`.
"""
function read_block_with_corrections(snap::String, fieldname::String; parttype::Int64,
                                     h::Union{Nothing,SnapshotHeader}=nothing)
    block_data = if (length(fieldname) > 3) && (fieldname[1:3] == "VEL" || fieldname[1:4] in ["VRMS","VBLK","VTAN","VRAD"]) && fieldname[end] == 'C'
        z = if typeof(h) == Nothing
            read_header(snap).z
        else
            h.z
        end
        atime = 1/(1+z) # save for non-comoving simulations
        read_block(snap, fieldname[1:end-1], parttype=parttype, h=h) .* (atime^(3/2))
    else
        # default return option
        read_block(snap, fieldname, parttype=parttype, h=h)
    end
    # return only selected data
    selection = evaluate_selection_function_if_necessary(GadgetFilename(snap), parttype=parttype, reading_function=read_block)
    return restrict_to_selection(block_data, selection)
end
"""
    read_particles_in_box_with_corrections(snap::String, fieldname::String, corner_lowerleft, corner_upperright; parttype::Int64, use_keys::Bool=false)

Read particles in box, but include some customized corrections such as for the velocity if blocks start with `"VEL"`, `"VRMS"`, `"VBLK"`, `"VTAN"`, `"VRAD"` and end with `"C"`.
Also compare `read_particles_in_box` from `GadgetIO`.
"""
function read_particles_in_box_with_corrections(snap::String, fieldname::String, corner_lowerleft, corner_upperright; parttype::Int64, use_keys::Bool=false)
    block_data = if (length(fieldname) > 3) && (fieldname[1:3] == "VEL" || fieldname[1:4] in ["VRMS","VBLK","VTAN","VRAD"]) && fieldname[end] == 'C'
        atime = 1/(1+read_header(snap).z) # save for non-comoving simulations
        return read_particles_in_box(snap, fieldname[1:end-1], corner_lowerleft, corner_upperright, parttype=parttype, use_keys=use_keys) .* (atime^(3/2))
    else
        # default return option
        read_particles_in_box(snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=use_keys)
    end
    # return only selected data
    selection = evaluate_selection_function_if_necessary(GadgetFilename(snap), parttype=parttype,
                                                         reading_function=(snap,fieldname; parttype=parttype)->read_particles_in_box(snap,fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=use_keys))
    return restrict_to_selection(block_data, selection)
end

# snapshot reading functions
"""
    get_snap_data(data::GadgetFilename, fieldname::String; parttype::Int64=0)

Read snapshot data from `data.snap` with `fieldname` and `parttype`.
"""
function get_snap_data(data::GadgetFilename, fieldname::String; parttype::Int64=0)
    return read_block_with_corrections(data.snap, fieldname, parttype=parttype)
end
"""
    get_snap_data(data::GadgetFilenameWithData, fieldname::String; parttype::Int64=0)

Get snapshot data from `data.snap_data` if present, otherwise read from `data.snap`.
"""
function get_snap_data(data::GadgetFilenameWithData, fieldname::String; parttype::Int64=0)
    if has_snap_block(data,fieldname,parttype=parttype)
        return data.snap_data[(fieldname, parttype)]
    else
        return read_block_with_corrections(data.snap, fieldname, parttype=parttype, h=get_snap_header(data))
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
    if has_snap_block(data,fieldname,parttype=parttype)
        return data.snap_data[(fieldname, parttype)]
    else
        new_snap_data = read_block_with_corrections(data.snap, fieldname, parttype=parttype, h=get_snap_header!(data))
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
    return read_particles_in_box_with_corrections(data.snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=false)
end
"""
    get_snap_data_in_box(data::GadgetFilenameWithData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

Get snapshot data from `data.snap_data` if present, otherwise read from `data.snap`.
"""
function get_snap_data_in_box(data::GadgetFilenameWithData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    if has_snap_block(data,fieldname,parttype=parttype)
        pos = get_snap_data(data,"POS",parttype=parttype)
        index = (corner_lowerleft[1] .< pos[1,:] .< corner_upperright[1]) .&
            (corner_lowerleft[2] .< pos[2,:] .< corner_upperright[2]) .&
            (corner_lowerleft[3] .< pos[3,:] .< corner_upperright[3])
        if ndims(data.snap_data[(fieldname, parttype)]) == 1
            return data.snap_data[(fieldname, parttype)][index]
        else # == 2
            return data.snap_data[(fieldname, parttype)][:,index]
        end
    else
        return read_particles_in_box_with_corrections(data.snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=false)
    end
end
"""
    get_snap_data_in_box(data::GadgetOnlyData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)

Get snapshot data from `data.snap_data`.
"""
function get_snap_data_in_box(data::GadgetOnlyData, fieldname::String, corner_lowerleft::Array{<:Real}, corner_upperright::Array{<:Real}; parttype::Int64=0)
    pos = get_snap_data(data,"POS",parttype=parttype)
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
    if has_snap_block(data,fieldname,parttype=parttype)
        return get_snap_data_in_box(data, fieldname, corner_lowerleft, corner_upperright, parttype=parttype)
    else
        new_snap_data = read_particles_in_box_with_corrections(data.snap, fieldname, corner_lowerleft, corner_upperright, parttype=parttype, use_keys=false)
        data.snap_data[(fieldname,parttype)] = new_snap_data
        return new_snap_data
    end
end

# snapshot header reading functions
"""
    get_snap_header(data::GadgetFilename)

Read snapshot header from `data.snap` with `fieldname` and `parttype`.
"""
function get_snap_header(data::GadgetFilename)
    return read_header(data.snap)
end
"""
    get_snap_header(data::GadgetFilenameWithData)

Get snapshot header from `data.snap_data` if present, otherwise read from `data.snap`.
"""
function get_snap_header(data::GadgetFilenameWithData)
    if haskey(data.snap_data,"HEAD")
        return data.snap_data["HEAD"]
    else
        return read_header(data.snap)
    end
end
"""
    get_snap_header(data::GadgetOnlyData)

Get snapshot header from `data.snap_data`.
"""
function get_snap_header(data::GadgetOnlyData)
    return data.snap_data["HEAD"]
end

# snapshot reading functions to add the header just read
"""
    get_snap_header!(data::GadgetData)

See `get_snap_header(data::GadgetData)`
"""
function get_snap_header!(data::GadgetData)
    return get_snap_header(data)
end
"""
    get_snap_header(data::GadgetFilenameWithData)

Get snapshot header from `data.snap_data` if present, otherwise read from `data.snap` and save in `data.snap_data`.
"""
function get_snap_header!(data::GadgetFilenameWithData)
    if haskey(data.snap_data,"HEAD")
        return data.snap_data["HEAD"]
    else
        new_snap_data = read_header(data.snap)
        data.snap_data["HEAD"] = new_snap_data
        return new_snap_data
    end
end
