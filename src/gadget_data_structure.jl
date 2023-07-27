abstract type GadgetData end

"""
    GadgetFilename <: GadgetData

Datatype to hold Gadget `snap` and `sub` filenames.
"""
struct GadgetFilename <: GadgetData
    snap::String
    sub::String
    
    function GadgetFilename(snap::String, sub::String)
        new(snap,sub)
    end
    function GadgetFilename(snap::String)
        new(snap,snap2sub(snap))
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
    """
        GadgetFilenameWithData(snap::String,sub::String, snap_data::Dict,sub_data::Dict)

    Construct a `GadgetFilenameWithData`.
    """
    function GadgetFilenameWithData(snap::String,sub::String, snap_data::Dict,sub_data::Dict)
        new(snap,sub, snap_data,sub_data)
    end
    """
        GadgetFilenameWithData(snap::String, snap_data::Dict,sub_data::Dict)

    Construct a `GadgetFilenameWithData`. Obtain `sub` name from `snap`.
    """
    function GadgetFilenameWithData(snap::String, snap_data::Dict,sub_data::Dict)
        new(snap,snap2sub(snap), snap_data,sub_data)
    end
    """
        GadgetFilenameWithData(snap::String, sub::String)

    Construct a `GadgetFileWithData` with un-initialzed `snap_data` and `sub_data`.
    """
    function GadgetFilenameWithData(snap::String, sub::String)
        new(snap,sub, Dict(),Dict())
    end
    """
        GadgetFilenameWithData(snap::String)

    Construct a `GadgetFileWithData` with un-initialzed `snap_data` and `sub_data`. Obtain `sub` name from `snap`.
    """
    function GadgetFilenameWithData(snap::String)
        new(snap,snap2sub(snap), Dict(),Dict())
    end
    
end

"""
    GadgetOnlyData <: GadgetData

Datatype to hold `snap_data` and `sub_data`.
"""
mutable struct GadgetOnlyData <: GadgetData
    snap_data::Dict
    sub_data::Dict
    """
        GadgetOnlyData(snap_data::Dict, sub_data::Dict)

    Construct `GadgetOnlyData` with `snap_data` and `sub_data`.
    """
    function GadgetOnlyData(snap_data::Dict, sub_data::Dict)
        new(snap_data,sub_data)
    end
end
