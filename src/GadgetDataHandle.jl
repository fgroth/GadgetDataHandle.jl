module GadgetDataHandle

include("gadget_data_structure.jl")
export GadgetData, GadgetFilename,
    GadgetFilenameWithData, GadgetOnlyData,
    default_selection_function

include("snap_reader.jl")
export get_snap_data, get_snap_data!,
    get_snap_data_in_box,get_snap_data_in_box!,
    get_snap_header, get_snap_header!
include("modify_snap.jl")

export set_snap_data!

include("sub_reader.jl")
export choose_subfind_fieldname,
    get_sub_data, get_sub_data!

include("helper_function.jl")

include("check_data.jl")
export has_snap_block, has_sub_block,
    has_snap_data, has_sub_data

include("remove_data.jl")
export remove_snap_data!, remove_sub_data!

include("gadget_general.jl")

include("simulation_data_structure.jl")
export GadgetSimulation,
    GadgetSimulationDir,
    GadgetSimulationDirWithData,
    largest_snapnum
include("simulation.jl")
export get_last_snapshot, get_last_snapnumber,
    get_snapshot

include("units.jl")
export GadgetUnits

include(joinpath("diagnostic_files","read_sfr.jl"))
export read_sfr_txt

include(joinpath("diagnostic_files","read_cpu.jl"))
export read_cpu_file, cpu_value_evolution

end # module
