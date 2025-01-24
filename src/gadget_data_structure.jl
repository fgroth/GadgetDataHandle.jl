abstract type GadgetData end

"""
    GadgetFilename <: GadgetData

Datatype to hold Gadget `snap` and `sub` filenames.
"""
struct GadgetFilename <: GadgetData
    snap::String
    sub::String
    selection_function::Function
    select_particle_types::BitVector
    
    function GadgetFilename(snap::String, sub::String;
                            selection_function::Function=(i->true), select_particle_types::Union{Nothing,BitVector}=nothing)
        new(snap,sub,
            selection_function,get_select_particle_types(select_particle_types))
    end
    function GadgetFilename(snap::String; kwargs...)
        GadgetFilename(snap,snap2sub(snap); kwargs...)
    end
end

"""
    get_select_particle_types(select_particle_types::Union{Nothing,BitVector})

Return default select_particle_types for `nothing` and otherwise check the length to be 6.
"""
function get_select_particle_types(select_particle_types::Union{Nothing,BitVector})
    if select_particle_types == nothing
        select_particle_types = BitVector(undef,6)
        select_particle_types .= false
    else
        if length(select_particle_types != 6)
            error("Length of select_particle_type must be 6.")
        end
    end
end

"""
    GadgetFilenameWithData <: GadgetData

Datatype to hold `snap` and `sub` filenames as well as `snap_data`and `sub_data`.
"""
mutable struct GadgetFilenameWithData <: GadgetData
    snap::String
    sub::String
    snap_data::Dict
    sub_data::Dict
    selection_function::Function
    select_particle_types::BitVector
    """
        GadgetFilenameWithData(snap::String,sub::String)

    Construct a `GadgetFilenameWithData` with un-initialzed `snap_data` and `sub_data`.
    """
    function GadgetFilenameWithData(snap::String,sub::String;
                                    selection_function::Function=(i->true), select_particle_types::Union{Nothing,BitVector}=nothing)
        new(snap,sub,
            Dict(),Dict(),
            selection_function, get_select_particle_types(select_particle_types))
    end
    """
        GadgetFilenameWithData(snap::String)

    Construct a `GadgetFilenameWithData`. Obtain `sub` name from `snap`.
    """
    function GadgetFilenameWithData(snap::String; kwargs...)
        GadgetFilenameWithData(snap,snap2sub(snap); kwargs...)
    end
    
end

"""
    GadgetOnlyData <: GadgetData

Datatype to hold `snap_data` and `sub_data`.
"""
mutable struct GadgetOnlyData <: GadgetData
    snap_data::Dict
    sub_data::Dict
    selection_function::Function
    select_particle_types::BitVector
    """
        GadgetOnlyData(snap_data::Dict, sub_data::Dict)

    Construct `GadgetOnlyData` with  with un-initialzed `snap_data` and `sub_data`.
    """
    function GadgetOnlyData(; selection_function::Function=(i->true), select_particle_types::Union{Nothing,BitVector}=nothing)
        new(Dict(), Dict(),
            selection_function, get_select_particle_types(select_particle_types))
    end
end
