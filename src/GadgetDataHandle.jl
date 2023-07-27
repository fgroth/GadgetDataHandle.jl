module GadgetDataHandle

include("gadet_data_structure.jl")
export GadgetData, GadgetFilename,
    GadgetFilenameWithData, GadgetOnlyData

include("snap_reader.jl")
export get_snap_data, get_snap_data!,
    get_snap_header, get_snap_header!

include("sub_reader.jl")
export get_sub_data, get_sub_data!

include("remove_data.jl")
export remove_snap_data!, remove_sub_data!

end # module
