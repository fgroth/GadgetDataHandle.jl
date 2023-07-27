module GadgetDataHandle

include("gadet_data_structure.jl")
export GadgetData, GadgetFilename,
    GadgetFilenameWithData, GadgetOnlyData

include("snap_reader.jl")
export get_snap_data, get_snap_data!,
    get_snap_header, get_snap_header!

end # module
